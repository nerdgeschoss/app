# frozen_string_literal: true

class Views::Users::Index < Views::Base
  prop :users, _Any
  prop :filter, String
  prop :hide_financials, _Boolean, default: false

  def view_template
    render Container.new do
      stack do
        text(type: :"h1-bold") { "Users" }
        stack(line: :mobile, size: 4) do
          ["employee", "sprinter", "hr", "archive"].each do |f|
            a(href: users_path(filter: f)) do
              render Pill.new(active: f == @filter) { f }
            end
          end
        end
        @users.each do |user|
          render Card.new(
            href: user_path(user),
            icon: UserAvatar.new(url: user.avatar_image(size: 80)),
            title: user_title(user),
            subtitle: UserSubtitle.new(user:, hide_financials: @hide_financials)
          )
        end
      end
    end
  end

  private

  def user_title(user)
    if user.nick_name.present?
      "#{user.full_name} (#{user.nick_name})"
    else
      user.full_name
    end
  end

  class UserAvatar < Components::Base
    prop :url, String

    def view_template
      img(src: @url, alt: "")
    end
  end

  class UserSubtitle < Components::Base
    prop :user, User
    prop :hide_financials, _Boolean, default: false

    def view_template
      stack(line: :mobile, size: 4, align: :center) do
        unless @hide_financials
          if @user.remaining_holidays
            plain "#{@user.remaining_holidays} days off left"
          end
        end
        @user.team_member_of.each do |team|
          render Pill.new { team }
        end
      end
      unless @hide_financials
        salary = @user.current_salary
        if salary
          div do
            plain "#{format_currency(salary.brut)} since #{I18n.l(salary.valid_from.to_date)}"
          end
        end
      end
    end

    private

    def format_currency(amount)
      view_context.number_to_currency(amount, unit: "€", format: "%n %u")
    end
  end
end
