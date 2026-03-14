# frozen_string_literal: true

class Views::Base < Components::Base
  def around_template(&block)
    if Current.user
      render Layout.new(user: Current.user) { super(&block) }
    else
      super(&block)
    end
  end

  def simple_form_for(model, **options, &block)
    options[:builder] ||= ComponentFormBuilder
    output = view_context.simple_form_for(model, **options) { |builder|
      yield Phlex::Rails::Builder.new(builder, component: self)
    }
    raw(output)
  end

  def cache_store = Rails.cache
end
