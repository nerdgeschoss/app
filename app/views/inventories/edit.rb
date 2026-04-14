# frozen_string_literal: true

class Views::Inventories::Edit < Components::Base
  prop :inventory, Inventory

  def view_template
    form_with(model: @inventory, url: inventory_path(@inventory), method: :patch, builder: ComponentFormBuilder) do |f|
      stack do
        f.text_field :name
        f.text_area :details
        f.date_field :received_at
        f.date_field :returned_at
        stack(line: :mobile) do
          f.submit "Save"
        end
      end
    end
    delete_form
  end

  private

  def delete_form
    output = view_context.button_to("Delete", inventory_path(@inventory), method: :delete, class: "button")
    raw(output)
  end
end
