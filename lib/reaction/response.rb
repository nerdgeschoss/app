# frozen_string_literal: true

module Reaction
  class Response
    attr_reader :schema, :component

    def initialize(component:, context:)
      @context = context
      @component = component
      path = Rails.root.join("app", "views", "#{component}.props.rb")
      @schema = Reaction::Props::Schema.new(File.read(path)) if File.exist?(path)
    end

    def to_s
      path = @context.request.path
      props = schema.serialize(@context)
      globals = schema.root.fields.values.select { _1.global.present? }.map! { [_1.name, _1.global] }.to_h
      {
        path:,
        component:,
        props:,
        globals:
      }.to_json
    end
  end
end
