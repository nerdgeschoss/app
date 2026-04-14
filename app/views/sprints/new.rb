# frozen_string_literal: true

class Views::Sprints::New < Components::Base
  prop :sprint, Sprint

  def view_template
    stack do
      form_with(model: @sprint, url: sprints_path, builder: ComponentFormBuilder) do |f|
        stack do
          f.text_field :title
          f.date_field :sprint_from
          f.date_field :sprint_until
          f.number_field :working_days
          f.submit "Save"
        end
      end
    end
  end
end
