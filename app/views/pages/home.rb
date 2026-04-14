# frozen_string_literal: true

class Views::Pages::Home < Views::Base
  prop :upcoming_leaves, _Any
  prop :payslips, _Any
  prop :remaining_holidays, Integer
  prop :needs_retro_for, _Nilable(_Any), default: nil

  def view_template
    render Container.new do
      stack do
        text(type: :"h1-bold") { "Hello, #{Current.user.display_name}" }
        render Columns.new do
          render_retro_card if @needs_retro_for
          tag(:"turbo-frame", id: "daily_nerd", src: daily_nerd_message_path("current"))
          render_leaves_card if @upcoming_leaves.any?
          render_payslips_card if @payslips.any?
          render_holidays_card
        end
      end
    end
  end

  private

  def render_retro_card
    render Card.new(icon: "🚀", title: "Missing Retro", subtitle: @needs_retro_for.sprint.title) do
      render Button.new(title: "Leave retro notes", href: sprint_feedback_path(@needs_retro_for))
    end
  end

  def render_leaves_card
    render Card.new(icon: "🏝️", title: "Upcoming Holidays") do
      stack(size: 4) do
        @upcoming_leaves.each do |leave|
          div do
            plain "#{I18n.l(leave.leave_from.to_date)} – #{I18n.l(leave.leave_until.to_date)} (#{leave.number_of_days}): #{leave.title}"
          end
        end
      end
    end
  end

  def render_payslips_card
    render Card.new(icon: "💸", title: "Last Payments") do
      stack(size: 2) do
        @payslips.each do |payslip|
          if payslip.pdf.attached?
            a(href: view_context.url_for(payslip.pdf), target: "_blank") do
              plain I18n.l(payslip.month, format: "%B %Y")
            end
          else
            plain I18n.l(payslip.month, format: "%B %Y")
          end
        end
        a(href: payslips_path) do
          plain "Payslip Archive"
        end
      end
    end
  end

  def render_holidays_card
    render Card.new(
      icon: "⏰",
      title: "Remaining Holidays",
      subtitle: "#{@remaining_holidays} days left"
    )
  end
end
