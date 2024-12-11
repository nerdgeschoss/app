module Reaction
  class Response
    attr_reader :schema, :component

    def initialize(component:, context:)
      @context = context
      @component = component
      @schema = Reaction::Props::Schema.new(File.read(Rails.root.join("app", "views", "#{component}.props.rb")))
    end

    def to_s
      props = schema.serialize(@context)
      globals = schema.root.fields.values.select { _1.global.present? }.map! { [_1.name, _1.global] }.to_h
      {
        component:,
        props:,
        globals:
      }.to_json
    end
  end
end
