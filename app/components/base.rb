# frozen_string_literal: true

class Components::Base < Phlex::HTML
  extend Literal::Properties

  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes

  register_value_helper :vite_asset_path

  def stack(**, &block)
    render Stack.new(**, &block)
  end

  def text(**, &block)
    render Text.new(**, &block)
  end

  def icon(**, &block)
    render Icon.new(**, &block)
  end

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end
