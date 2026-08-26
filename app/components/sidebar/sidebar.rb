# frozen_string_literal: true

class Components::Sidebar < Components::Base
  prop :user, User

  Item = Data.define(:label, :path, :icon).freeze

  def view_template
    nav(class: "sidebar", data: {controller: "sidebar"}) do
      header(class: "sidebar__header", aria_label: "sidebar-header") do
        div(class: "sidebar__brand") do
          a(href: root_path) { render Components::Logo.new }
          div(class: "sidebar__company") do
            text(type: "label-heading-primary", color: "text-text-primary-base", uppercase: true) { "Nerdgeschoss" }
          end
        end
        button(
          class: "sidebar__menu-toggle",
          data: {action: "sidebar#toggle"},
          aria_label: t(".toggle_menu"),
          aria_expanded: "false"
        ) do
          span(class: "sidebar__burger") { icon(name: "menu", size: 24, color: "icon-menu-default") }
          div(class: "sidebar__close") { icon(name: "close", size: 24, color: "icon-menu-default") }
        end
      end
      div(class: "sidebar__collapse") do
        div(class: "sidebar__mobile") do
          div(class: "sidebar__links") do
            stack(size: 24, tablet_size: 32, desktop_size: 48) do
              items.each { |item| mobile_link(item) }
            end
          end
          div(class: "sidebar__footer") do
            profile_link do
              img(src: @user.avatar_image(size: 200), class: "sidebar__avatar", alt: "avatar")
              username
            end
            a(href: logout_path) do
              div(class: "sidebar__link") do
                icon(name: "logout", size: 24, desktop_size: 32)
                link_text(t(".logout"))
              end
            end
          end
        end
      end
      div(class: "sidebar__links") do
        items.each { |item| desktop_link(item) }
      end
      div(class: "sidebar__footer") do
        profile_link do
          render Components::Avatar.new(avatar_url: @user.avatar_image(size: 200), display_name: @user.display_name, email: @user.email, large: true)
          username
        end
        a(href: logout_path) do
          render Components::Tooltip.new(label: t(".logout")) do
            div(class: "sidebar__link") do
              icon(name: "logout", size: 24, desktop_size: 32)
            end
          end
        end
      end
    end
  end

  private

  def items
    list = [
      Item.new(t(".dashboard"), root_path, "dashboard"),
      Item.new(t(".sprints"), sprints_path, "sprint"),
      Item.new(t(".leaves"), leaves_path, "leave"),
      Item.new(t(".payslips"), payslips_path, "payslip"),
      Item.new(t(".projects"), projects_path, "project"),
      Item.new(t(".users"), users_path, "user")
    ]
    list << Item.new(t(".profits"), profits_path, "profit") if (@user.roles & ["hr", "admin"]).any?
    list
  end

  def active?(item)
    current = without_locale(request.path)
    target = without_locale(item.path)
    return current == target if target == "/"
    current.start_with?(target)
  end

  # Path helpers include the locale prefix (/en/users), the request path may omit it (/users).
  def without_locale(path)
    path.sub(%r{\A/(#{I18n.available_locales.join("|")})(?=/|\z)}, "").presence || "/"
  end

  def desktop_link(item)
    a(href: item.path) do
      render Components::Tooltip.new(label: item.label) do
        div(class: ["sidebar__link", ("sidebar__link--active" if active?(item))]) do
          icon(name: item.icon, size: 24, desktop_size: 32)
        end
      end
    end
  end

  def mobile_link(item)
    a(href: item.path) do
      div(class: ["sidebar__link", ("sidebar__link--active" if active?(item))]) do
        icon(name: item.icon, size: 24, desktop_size: 32)
        link_text(item.label)
      end
    end
  end

  def link_text(label)
    div(class: "sidebar__link-text") do
      text(type: "menu-semibold", color: "text-text-primary-base") { label }
    end
  end

  def profile_link(&block)
    a(href: user_path(@user)) do
      stack(line: "mobile", align: "center", size: 10, &block)
    end
  end

  def username
    div(class: "sidebar__footer-username") do
      text(type: "menu-semibold") { @user.display_name }
    end
  end
end
