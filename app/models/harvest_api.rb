# frozen_string_literal: true

class HarvestApi
  include Singleton

  TimeEntry = Struct.new(:id, :date, :hours, :rounded_hours, :billable, :project, :project_id, :invoice_id, :client, :task, :billable_rate, :cost_rate, :notes, :user, :response, keyword_init: true)
  User = Struct.new(:id, :first_name, :last_name, :email, :weekly_capacity, keyword_init: true)
  Invoice = Struct.new(:id, :reference, :amount, :state, :sent_at, :paid_at, :project_id, :project_name, :client_name, keyword_init: true)

  def me
    OpenStruct.new(get("users/me"))
  end

  def time_entries(from: nil, to: nil)
    query = {from: from.to_date, to: to.to_date}.compact
    response = get_all("time_entries", query:)
    emails_by_id = users.map { |e| [e.id, e.email] }.to_h
    response.map do |e|
      TimeEntry.new(
        **e.slice(:hours, :rounded_hours, :billable, :billable_rate, :cost_rate, :notes)
          .merge(id: e[:id].to_s, date: e[:spent_date]&.to_date, project: e.dig(:project, :name), project_id: e.dig(:project, :id),
            client: e.dig(:client, :name), user: emails_by_id[e.dig(:user, :id)], task: e.dig(:task, :name), invoice_id: e.dig(:invoice, :id), response: e)
      )
    end
  end

  def users
    get_all("users").map { |e| User.new(**e.slice(:id, :first_name, :last_name, :email, :weekly_capacity)) }
  end

  def invoices
    get_all("invoices").map do |invoice|
      project = invoice[:line_items]&.map { |e| e[:project] }&.compact&.first
      Invoice.new(invoice.slice(:id, :amount, :state, :sent_at, :paid_at).merge(reference: invoice[:number], project_id: project&.dig(:id), project_name: project&.dig(:name), client_name: invoice.dig(:client, :name)))
    end
  end

  private

  def api(path)
    "https://api.harvestapp.com/v2/#{path}"
  end

  def get(path, **options)
    response = HTTParty.get(api(path), headers:, **options)
    raise StandardError, "wrong response from Harvest: #{response.code} #{response.message}" unless response.ok?

    response
  end

  def get_all(path, **options)
    values = []
    options_without_query = options.excluding(:query)
    next_page = :first
    field = path
    until next_page.nil?
      response = if next_page == :first
        HTTParty.get(api(path), headers:, **options)
      else
        HTTParty.get(next_page, headers:, **options_without_query)
      end
      raise StandardError, "wrong response from Harvest: #{response.code} #{response.message}" unless response.ok?

      values += response[field]
      next_page = response.dig("links", "next")
    end

    values.map(&:with_indifferent_access)
  end

  def headers
    @headers ||= {
      "Authorization" => "Bearer #{Config.harvest_access_token!}",
      "Harvest-Account-Id" => Config.harvest_account_id!
    }
  end
end
