# frozen_string_literal: true

class Views::Inventories::New < Components::Base
  prop :inventory, Inventory

  def view_template
    form_with(model: @inventory, url: inventories_path, builder: ComponentFormBuilder) do |f|
      stack do
        f.hidden_field :user_id
        f.text_field :name
        f.text_area :details
        f.date_field :received_at
        f.submit "Save"
      end
    end
  end
end
