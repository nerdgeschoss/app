# frozen_string_literal: true

class Views::Leaves::Index < Views::Base
  prop :leaves, _Any
  prop :status, Symbol
  prop :permit_create, _Boolean, default: false
  prop :feed_url, _Nilable(String), default: nil

  FILTERS = {all: "All", pending_approval: "Pending", approved: "Approved", rejected: "Rejected"}.freeze
  STATUS_LABELS = {pending_approval: "Pending", approved: "Approved", rejected: "Rejected"}.freeze

  def view_template
    render Container.new do
      stack do
        render_header
        render_filters
        render_leaves
        render_pagination
      end
    end
  end

  private

  def render_header
    stack(line: :mobile, justify: :"space-between") do
      text(type: :"h1-bold") { "Leaves" }
      stack(line: :mobile, size: 8) do
        a(href: @feed_url) { "Subscribe" } if @feed_url
        render Button.new(title: "Request leave", modal_path: new_leave_path) if @permit_create
      end
    end
  end

  def render_filters
    stack(line: :mobile, size: 4) do
      FILTERS.each do |key, label|
        a(href: leaves_path(status: key)) do
          render Pill.new(active: key == @status) { label }
        end
      end
    end
  end

  def render_leaves
    stack do
      @leaves.each do |leave|
        render_leave_card(leave)
      end
    end
  end

  def render_leave_card(leave)
    presenter = leave.presenter
    dates = leave.days.sort
    date_text = "#{I18n.l(dates.first)} – #{I18n.l(dates.last)}"
    subtitle_text = "#{date_text} (#{leave.number_of_days}) · #{STATUS_LABELS[leave.status.to_sym]}"

    render Card.new(
      id: "leave_#{leave.id}",
      icon: presenter.unicode_emoji,
      title: "#{leave.user.display_name} / #{leave.title}",
      subtitle: subtitle_text,
      context: leave_actions(leave)
    )
  end

  def leave_actions(leave)
    actions = []
    if policy(leave).approve?
      actions << approve_button(leave, "approved", "👍")
      actions << approve_button(leave, "rejected", "👎")
    end
    actions << delete_button(leave) if policy(leave).destroy?
    return nil if actions.empty?

    LeaveActions.new(leave:, actions:)
  end

  def approve_button(leave, new_status, label)
    {leave:, status: new_status, label:}
  end

  def delete_button(leave)
    {leave:, delete: true}
  end

  def render_pagination
    return unless @leaves.next_page

    render Button.new(title: "Load more", href: leaves_path(status: @status, page: @leaves.next_page))
  end

  def policy(record)
    Pundit.policy!(Current.user, record)
  end

  class LeaveActions < Components::Base
    prop :leave, _Any
    prop :actions, _Any

    def view_template
      stack(line: :mobile, size: 4) do
        @actions.each do |action|
          if action[:delete]
            raw(view_context.button_to("🗑️", leave_path(@leave), method: :delete, class: "button"))
          else
            raw(view_context.button_to(
              action[:label],
              leave_path(action[:leave]),
              method: :patch,
              class: "button",
              params: {leave: {status: action[:status]}}
            ))
          end
        end
      end
    end
  end
end
