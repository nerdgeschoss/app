class HarvestApi
  TimeEntry = Struct.new(:id, :date, :hours, :rounded_hours, :billable, :project, :client, :task, :billable_rate, :cost_rate, :notes, :user, :response, keyword_init: true)
  User = Struct.new(:id, :first_name, :last_name, :email, :weekly_capacity, keyword_init: true)

  include Singleton

  def me
    OpenStruct.new(get("users/me"))
  end

  def time_entries(from: nil, to: nil)
    query = {from: from.to_date, to: to.to_date}.compact
    response = get_all("time_entries", query: query)
    emails_by_id = users.map { |e| [e.id, e.email] }.to_h
    response.map do |e|
      TimeEntry.new(
        **e.slice(:hours, :rounded_hours, :billable, :billable_rate, :cost_rate, :notes)
          .merge(id: e[:id].to_s, date: e[:spent_date]&.to_date, project: e.dig(:project, :name), client: e.dig(:client, :name), user: emails_by_id[e.dig(:user, :id)], task: e.dig(:task, :name), response: e)
      )
    end
  end

  def users
    get_all("users").map { |e| User.new(**e.slice(:id, :first_name, :last_name, :email, :weekly_capacity)) }
  end

  private

  def api(path)
    "https://api.harvestapp.com/v2/#{path}"
  end

  def get(path, **options)
    response = HTTParty.get api(path), headers: headers, **options
    raise StandardError, "wrong response from Harvest: #{response.code} #{response.message}" unless response.ok?

    response
  end

  def get_all(path, **options)
    values = []
    options_without_query = options.excluding(:query)
    next_page = :first
    field = path
    until next_page.nil?
      response = next_page == :first ?
        HTTParty.get(api(path), headers: headers, **options) :
        HTTParty.get(next_page, headers: headers, **options_without_query)
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
