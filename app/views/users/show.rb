# frozen_string_literal: true

class Views::Users::Show < Views::Base
  prop :user, User
  prop :salaries, _Any
  prop :inventories, _Any
  prop :hide_financials, _Boolean, default: false
  prop :permit_edit_inventory, _Boolean, default: false

  def view_template
    render Container.new do
      stack do
        text(type: :"h1-bold") { @user.full_name }
        render Columns.new do
          render_holidays_card unless @hide_financials
          render_salary_card if @salaries.any? && !@hide_financials
          render_inventory_card if @inventories.any? || @permit_edit_inventory
          render_api_token_card if @user == Current.user
        end
      end
    end
  end

  private

  def render_holidays_card
    return unless @user.remaining_holidays

    render Card.new(
      title: "Remaining holidays",
      subtitle: @user.remaining_holidays.to_s,
      icon: "⏰"
    )
  end

  def render_salary_card
    render Card.new(title: "Salary history", icon: "💰") do
      stack do
        @salaries.each do |salary|
          if salary.hgf_hash
            a(href: "https://nerdgeschoss.de/handbook/hgf/##{salary.hgf_hash}", target: "_blank") do
              render_salary_entry(salary)
            end
          else
            render_salary_entry(salary)
          end
        end
      end
    end
  end

  def render_salary_entry(salary)
    div { plain I18n.l(salary.valid_from.to_date) }
    div { plain format_currency(salary.brut) }
  end

  def render_inventory_card
    context = if @permit_edit_inventory
      AddInventoryButton.new(user: @user)
    end

    render Card.new(title: "Inventory", icon: "💻", context:) do
      stack do
        @inventories.each do |inventory|
          stack(size: 4) do
            render Button.new(title: inventory.name, modal_path: edit_inventory_path(inventory))
            text { inventory.details } if inventory.details.present?
            text do
              if inventory.returned_at
                plain "#{I18n.l(inventory.received_at.to_date)} – #{I18n.l(inventory.returned_at.to_date)}"
              else
                plain I18n.l(inventory.received_at.to_date)
              end
            end
          end
        end
      end
    end
  end

  def render_api_token_card
    render Card.new(title: "API Token", icon: "🔑") do
      plain @user.api_token
    end
  end

  def format_currency(amount)
    view_context.number_to_currency(amount, unit: "€", format: "%n %u")
  end

  class AddInventoryButton < Components::Base
    prop :user, User

    def view_template
      render Button.new(title: "add", modal_path: new_user_inventory_path(@user))
    end
  end
end
