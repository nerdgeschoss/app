# frozen_string_literal: true

class Components::NavigationPills < Components::Base
  include Phlex::Rails::Helpers::URLFor

  prop :filters, _Hash(_Union(String, Symbol), String)

  def view_template
    stack(line: "mobile", size: 4) do
      @filters.each do |id, label|
        a(href: filter_url(id), data: {turbo_action: "replace"}) do
          render Components::Pill.new(active: id.to_s == active) { label }
        end
      end
    end
  end

  private

  # The active filter comes from the url; without (or with an unknown) filter
  # parameter the first filter is considered active.
  def active
    @active ||= begin
      ids = @filters.keys.map(&:to_s)
      ids.include?(request.query_parameters["filter"]) ? request.query_parameters["filter"] : ids.first
    end
  end

  # The current url with the filter parameter replaced, keeping everything else.
  def filter_url(id)
    url_for(request.query_parameters.merge("filter" => id.to_s).symbolize_keys)
  end
end
