# frozen_string_literal: true

class Views::Sprints::New < Components::Base
  prop :sprint, Sprint

  def view_template
    stack do
      simple_form_for(@sprint, url: sprints_path) do |f|
        stack do
          f.input :title
          f.input :sprint_from, as: :date
          f.input :sprint_until, as: :date
          f.input :working_days
          f.submit "Save"
        end
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
