# frozen_string_literal: true

class Components::TextField < Components::Base
  TYPES = ["text", "email", "url"].freeze

  prop :name, String
  prop :id, String
  prop :type, _Union(*TYPES), default: "text"
  prop :value, _Nilable(String)
  prop :options, Hash, default: -> { {} }

  def view_template
    input(type: @type, name: @name, id: @id, value: @value, class: "text-field", **@options)
  end
end
