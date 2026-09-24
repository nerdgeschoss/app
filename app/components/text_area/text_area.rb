# frozen_string_literal: true

class Components::TextArea < Components::Base
  prop :name, String
  prop :id, String
  prop :value, _Nilable(String)
  prop :options, Hash, default: -> { {} }

  def view_template
    textarea(name: @name, id: @id, class: "text-area", **@options) { @value }
  end
end
