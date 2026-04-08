# frozen_string_literal: true

class Views::Inventories::New < Components::Base
  prop :inventory, Inventory

  def view_template
    simple_form_for(@inventory, url: inventories_path) do |f|
      stack do
        f.input :user_id, as: :hidden
        f.input :name
        f.input :details
        f.input :received_at, as: :date
        f.submit "Save"
      end
    end
  end

  private

  def simple_form_for(model, **options, &block)
    options[:builder] ||= ComponentFormBuilder
    output = view_context.simple_form_for(model, **options) { |builder|
      yield Phlex::Rails::Builder.new(builder, component: self)
    }
    raw(output)
  end
end
