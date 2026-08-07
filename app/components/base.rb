# frozen_string_literal: true

class Components::Base < Phlex::HTML
  extend Literal::Properties

  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::T
  include Phlex::Rails::Helpers::L
  include Phlex::Rails::Helpers::NumberToCurrency
  include Phlex::Rails::Helpers::Request

  register_value_helper :vite_asset_path

  # Relative translation keys resolve against a scope derived from the class
  # name: Components::UserCard => "components.user_card", Views::Users::Index
  # => "users.index" (matching the lazy lookup scope of a classic Rails view).
  def t(key, **options)
    key = "#{translation_scope}#{key}" if key.is_a?(String) && key.start_with?(".")
    super
  end

  # Design token color names (mirrors the Color union in app/frontend/components/text/types.ts).
  COLORS = [
    "active", "arrow-button-bg-default", "button-primary-bg-default",
    "button-primary-bg-disabled", "button-primary-bg-hover", "button-primary-bg-pressed",
    "button-primary-label-default", "button-primary-label-hover", "button-primary-label-pressed",
    "button-secondary-bg-default", "button-secondary-bg-hover", "button-secondary-bg-pressed",
    "button-secondary-border-default", "button-secondary-border-hover", "button-secondary-border-pressed",
    "button-secondary-label-default", "button-secondary-label-hover", "button-secondary-label-pressed",
    "card-bg-default", "card-border-default", "chart-bg-billable",
    "chart-bg-default", "chart-bg-goal", "chart-bg-non-billable",
    "chart-border-holiday", "chart-border-pto", "chart-border-sick",
    "chart-fg-default", "color", "default",
    "div-default", "dropdown-bg-active", "dropdown-bg-default",
    "dropdown-bg-hover", "dropdown-bg-pressed", "dropdown-border-active",
    "dropdown-border-default", "dropdown-border-hover", "dropdown-border-pressed",
    "dropdown-label-active", "dropdown-label-default", "dropdown-label-hover",
    "dropdown-label-pressed", "hover", "icon-arrow-primary-active",
    "icon-arrow-primary-default", "icon-arrow-secondary-active", "icon-arrow-secondary-default",
    "icon-daily-nerd-empty", "icon-daily-nerd-filled", "icon-daily-nerd-no-entry",
    "icon-day-empty", "icon-day-filled", "icon-exit-default",
    "icon-header-series1", "icon-header-series2", "icon-header-series2-2",
    "icon-header-series3", "icon-menu-active", "icon-menu-default",
    "icon-navigation-active", "icon-navigation-default", "icon-navigation-hover",
    "icon-working-day-bg-empty", "icon-working-day-bg-filled", "icon-working-day-bg-non-working",
    "icon-working-day-bg-sick-leave", "icon-working-day-bg-vacation-leave", "icon-working-day-border-default",
    "icon-working-day-border-holiday", "icon-working-day-border-non-working", "icon-working-day-border-pto",
    "icon-working-day-border-sick-leave", "icon-working-day-fg-holiday", "icon-working-day-fg-leave",
    "input-default", "label-body-primary", "label-body-secondary",
    "label-caption-primary", "label-caption-secondary", "label-caption-strong",
    "label-heading-primary", "label-heading-secondary", "label-link-default",
    "label-link-hover", "label-link-pressed", "menu-bg-active",
    "menu-bg-default", "menu-bg-hover", "menu-label-active",
    "menu-label-default", "menu-label-hover", "modal-background-primary",
    "navigation-bg-default", "pressed", "progress-bar-bg-default",
    "progress-bar-fg-default", "screen-screen-bg-default", "status-pill-done",
    "tab-bg-active", "tab-bg-hover", "tab-bg-pressed",
    "tab-border-active", "tab-border-hover", "tab-border-pressed",
    "tab-label-active", "tab-label-default", "tab-label-hover",
    "tab-label-pressed", "text-text-primary-base", "text-warning",
    "tooltip-bg-default", "tooltip-hours-bg-active", "tooltip-hours-border-default",
    "tooltip-hours-label-default", "tooltip-label-default"
  ].freeze

  # Lowercase shortcuts for the primitives from the component guidelines,
  # e.g. `stack(line: "mobile") { ... }`. Everything else is rendered explicitly.
  [:icon, :stack, :text].each do |name|
    define_method(name) do |**props, &block|
      render(Components.const_get(name.to_s.camelize).new(**props), &block)
    end
  end

  private

  def translation_scope
    self.class.name.underscore.delete_prefix("views/").tr("/", ".")
  end
end
