# frozen_string_literal: true

class Components::UserCard < Components::Base
  prop :user, User
  prop :hide_financials, _Boolean, default: false

  def view_template
    render Components::Card.new(
      href: user_path(@user),
      icon: -> { img(src: @user.avatar_image(size: 80), alt: "") },
      title: [@user.full_name, @user.nick_name.presence && "(#{@user.nick_name})"].compact.join(" "),
      subtitle: -> { subtitle }
    )
  end

  private

  def subtitle
    stack(line: "mobile", size: 4, align: "center") do
      remaining_holidays = @user.remaining_holidays unless @hide_financials
      plain t(".number_holidays_left", count: remaining_holidays) if remaining_holidays
      @user.team_member_of.each { |team| render(Components::Pill.new) { team } }
    end
    salary = @user.current_salary unless @hide_financials
    return unless salary
    div do
      plain t(
        ".salary_since",
        amount: number_to_currency(salary.brut, unit: "€"),
        date: l(salary.valid_from, format: :month_year)
      )
    end
  end
end
