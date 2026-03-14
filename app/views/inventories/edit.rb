# frozen_string_literal: true

class Views::Inventories::Edit < Components::Base
  prop :inventory, Inventory

  def view_template
    simple_form_for(@inventory, url: inventory_path(@inventory), method: :patch) do |f|
      stack do
        f.input :name
        f.input :details
        f.input :received_at, as: :date
        f.input :returned_at, as: :date
        stack(line: :mobile) do
          f.submit "Save"
        end
      end
    end
    delete_form
  end

  private

  def simple_form_for(model, **options, &block)
    options[:builder] ||= ComponentFormBuilder
    output = view_context.simple_form_for(model, **options) { |builder|
      yield Phlex::Rails::Builder.new(builder, component: self)
    }
    raw(output)
  end

  def delete_form
    output = view_context.button_to("Delete", inventory_path(@inventory), method: :delete, class: "button")
    raw(output)
  end
end
