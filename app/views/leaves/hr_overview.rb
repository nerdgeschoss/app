# frozen_string_literal: true

class Views::Leaves::HrOverview < Views::Base
  prop :date, _Date
  prop :month, _Range(_Date)
  prop :users, _Enumerable(User)
  prop :leaves, _Enumerable(Leave)
  prop :day_counts, _Hash(User, _Hash(_String, _Integer))
  prop :pending_leaves, _Enumerable(Leave)

  def view_template
    render Components::Layout.new(user: current_user, container: true) do
      stack do
        text(type: "h1-bold") { t(".title") }

        @pending_leaves.each do |pending_leave|
          stack(line: "mobile") {
            text { pending_leave.user.display_name }
            text { pending_leave.type }
            text { l(pending_leave.leave_from.to_date) }
            text { l(pending_leave.leave_until.to_date) }
            text { pending_leave.number_of_days }
          }
        end

        link_to("previous month", params: {year: @date.prev_month.year, month: @date.prev_month.month})
        link_to("next month", params: {year: @date.next_month.year, month: @date.next_month.month})

        @users.each do |user|
          stack(line: "mobile") {
            link_to(user.display_name, user_leaves_path(user, params: {year: @date.year, month: @date.month}))
            Leave.types.keys.excluding("unpaid").each do |leave_type|
              text { leave_type }
              text { pluralize(@day_counts[user][leave_type].presence || 0, "day") }
            end
          }
        end
      end
    end
  end
end
