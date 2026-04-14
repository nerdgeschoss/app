# frozen_string_literal: true

class Views::Payslips::Index < Views::Base
  prop :payslips, _Any
  prop :permit_create, _Boolean, default: false
  prop :permit_destroy, _Boolean, default: false

  def view_template
    render Container.new do
      stack do
        stack(line: :mobile, justify: :"space-between") do
          text(type: :"h1-bold") { "Payslips" }
          render Button.new(title: "add", modal_path: new_payslip_path) if @permit_create
        end
        render Columns.new do
          @payslips.each do |payslip|
            render_payslip_card(payslip)
          end
        end
        if @payslips.next_page
          render Button.new(title: "more", href: payslips_path(page: @payslips.next_page))
        end
      end
    end
  end

  private

  def render_payslip_card(payslip)
    render Card.new(
      icon: "💸",
      title: payslip.user.display_name,
      subtitle: I18n.l(payslip.month, format: "%B %Y")
    ) do
      stack(line: :mobile, size: 8) do
        if payslip.pdf.attached?
          a(href: view_context.url_for(payslip.pdf), target: "_blank") { "⬇️" }
        end
        if @permit_destroy
          render Button.new(title: "delete", href: payslip_path(payslip), method: "delete", confirm: "Are you sure?")
        end
      end
    end
  end
end
