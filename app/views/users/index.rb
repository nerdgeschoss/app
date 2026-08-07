# frozen_string_literal: true

class Views::Users::Index < Views::Base
  FILTERS = ["employee", "sprinter", "hr", "archive"].freeze

  prop :users, _Enumerable(User)
  prop :hide_financials, _Boolean

  def view_template
    render Components::Layout.new(user: current_user, container: true) do
      stack do
        text(type: "h1-bold") { t(".title") }
        render Components::NavigationPills.new(filters:)
        @users.each { |user| render Components::UserCard.new(user:, hide_financials: @hide_financials) }
      end
    end
  end

  private

  def filters
    # i18n-tasks-use t('users.index.filters.archive') t('users.index.filters.employee') t('users.index.filters.hr') t('users.index.filters.sprinter')
    FILTERS.index_with { |name| t(".filters.#{name}") }
  end
end
