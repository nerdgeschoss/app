# frozen_string_literal: true

class Components::Sidebar < Components::Base
  prop :user, User

  LinkInfo = Data.define(:name, :path, :icon).freeze

  def view_template
    nav(class: "sidebar") do
      render_header
      render_collapse_menu
      render_desktop_links
      render_desktop_footer
    end
  end

  private

  def links
    [
      LinkInfo.new(name: "Dashboard", path: root_path, icon: :dashboard),
      LinkInfo.new(name: "Sprints", path: sprints_path, icon: :sprint),
      LinkInfo.new(name: "Leaves", path: leaves_path, icon: :leave),
      LinkInfo.new(name: "Payslips", path: payslips_path, icon: :payslip),
      LinkInfo.new(name: "Projects", path: projects_path, icon: :project),
      LinkInfo.new(name: "Users", path: users_path, icon: :user)
    ]
  end

  def current_path
    view_context.request.path.split("?").first
  end

  def active?(link)
    if link.path == root_path
      current_path == root_path
    else
      current_path.start_with?(link.path)
    end
  end

  def render_header
    header(aria_label: "sidebar-header", class: "sidebar__header") do
      div(class: "sidebar__brand") do
        a(href: root_path) { render Logo.new }
        div(class: "sidebar__company") do
          text(type: :"label-heading-primary", color: "text-text-primary-base", uppercase: true) { "Nerdgeschoss" }
        end
      end
      div(class: "sidebar__menu-toggle", onclick: "this.closest('nav').classList.toggle('sidebar--expanded')") do
        span(class: "sidebar__burger") { icon(name: :menu, size: 24, color: "icon-menu-default") }
        div(class: "sidebar__close") { icon(name: :close, size: 24, color: "icon-menu-default") }
      end
    end
  end

  def render_collapse_menu
    div(class: "sidebar__collapse") do
      div(class: "sidebar__mobile") do
        div(class: "sidebar__links") do
          stack(size: 24, tablet_size: 32, desktop_size: 48) do
            links.each { |link| render_mobile_link(link) }
          end
        end
        div(class: "sidebar__footer") do
          a(href: user_path(@user)) do
            stack(line: :mobile, align: :center, size: 10) do
              render Avatar.new(avatar_url: @user.avatar_image(size: 200), display_name: @user.display_name, email: @user.email)
              div(class: "sidebar__footer-username") do
                text(type: :"menu-semibold") { @user.display_name }
              end
            end
          end
          a(href: logout_path) do
            div(class: "sidebar__link") do
              icon(name: :logout, size: 24, desktop_size: 32)
              div(class: "sidebar__link-text") do
                text(type: :"menu-semibold", color: "text-text-primary-base") { "Logout" }
              end
            end
          end
        end
      end
    end
  end

  def render_mobile_link(link)
    a(href: link.path) do
      div(class: link_classes(link)) do
        icon(name: link.icon, size: 24, desktop_size: 32)
        div(class: "sidebar__link-text") do
          text(type: :"menu-semibold", color: "text-text-primary-base") { link.name }
        end
      end
    end
  end

  def render_desktop_links
    div(class: "sidebar__links") do
      stack(size: 24, tablet_size: 32, desktop_size: 48) do
        links.each { |link| render_desktop_link(link) }
      end
    end
  end

  def render_desktop_link(link)
    a(href: link.path) do
      render Tooltip.new(content: link.name) do
        div(class: link_classes(link)) do
          icon(name: link.icon, size: 24, desktop_size: 32)
        end
      end
    end
  end

  def render_desktop_footer
    div(class: "sidebar__footer") do
      a(href: user_path(@user)) do
        stack(line: :mobile, align: :center, size: 10) do
          render Avatar.new(avatar_url: @user.avatar_image(size: 200), display_name: @user.display_name, email: @user.email, large: true)
          div(class: "sidebar__footer-username") do
            text(type: :"menu-semibold") { @user.display_name }
          end
        end
      end
      a(href: logout_path) do
        render Tooltip.new(content: "Logout") do
          div(class: "sidebar__link") do
            icon(name: :logout, size: 24, desktop_size: 32)
          end
        end
      end
    end
  end

  def link_classes(link)
    classes = ["sidebar__link"]
    classes << "sidebar__link--active" if active?(link)
    classes.join(" ")
  end
end
