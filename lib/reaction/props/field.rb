# frozen_string_literal: true

module Reaction
  module Props
    class Field
      class Boolean < ::TrueClass; end
      attr_reader :name, :type, :null, :fields, :value_override, :global, :array, :parent

      def initialize(name, type = String, null: false, value: nil, global: nil, array: false, parent: nil, &block)
        @name = name
        @type = block ? Object : type
        @null = null
        @value_override = value
        @fields = {}
        @global = global
        @array = array
        @parent = parent
        instance_exec(&block) if block
      end

      def path
        parent ? "#{parent.path}.#{name}" : name
      end

      def serialize(value, array_content: false)
        return nil if value.nil? && null
        raise "Value is nil but null is false at #{path}" if value.nil? && !null

        if array && !array_content
          return value.map { |v| serialize(v, array_content: true) }
        end

        if type.nil?
          value
        elsif type == String
          value.as_json.to_s
        elsif type == Integer
          value.to_i
        elsif type == Float
          value.to_f
        elsif type == Date
          value.to_date.to_s
        elsif type == Time
          value.iso8601
        elsif type == Boolean
          !!value
        elsif type == JSON
          value.as_json
        elsif type == Object
          fields.map do |name, field|
            field_value = if field.value_override
              ValueProxy.new(value, context:).instance_exec(&field.value_override)
            else
              value.is_a?(Hash) ? value.with_indifferent_access[name] : value.try(name)
            end
            [name.to_s, field.serialize(field_value)]
          end.to_h
        else
          raise "Unknown type: #{type}"
        end
      end

      def to_typescript(skip_root: false, array_content: false)
        name = self.name.to_s.camelize(:lower)
        if array && !array_content
          content = to_typescript(skip_root: true, array_content: true)
          "#{name}: Array<#{(type == Object) ? "{#{content}}" : content}>"
        elsif array && type == String
          "string"
        elsif array && type == Integer
          "number"
        elsif array && type == Float
          "number"
        elsif array && type == Date
          "string"
        elsif array && type == Time
          "string"
        elsif array && type == Boolean
          "boolean"
        elsif type == String
          "#{name}: string#{null ? " | null" : ""};"
        elsif type == Integer
          "#{name}: number#{null ? " | null" : ""};"
        elsif type == Float
          "#{name}: number#{null ? " | null" : ""};"
        elsif type == Date
          "#{name}: string#{null ? " | null" : ""};"
        elsif type == Time
          "#{name}: string#{null ? " | null" : ""};"
        elsif type == Boolean
          "#{name}: boolean#{null ? " | null" : ""};"
        elsif type == JSON
          "#{name}: any#{null ? " | null" : ""};"
        elsif type == Object
          if skip_root
            fields.map { |name, field| field.to_typescript }.join("\n")
          else
            "#{name}: {\n#{fields.map { |name, field| field.to_typescript.indent(2) }.join("\n")}\n}#{null ? " | null" : ""};"
          end
        else
          raise "Unknown type: #{type}"
        end
      end

      def context
        parent&.context
      end

      private

      def field(name, type = String, null: false, value: nil, global: nil, array: false, &)
        @fields[name] = self.class.new(name, type, null:, value:, global:, array:, parent: self, &)
      end

      def render(name)
        path, file = name.split("/")
        name = Rails.root.join("app/views", path, "_#{file}.props.rb").to_s
        schema = File.read(name)
        Schema.new(schema).root.fields.each do |name, field|
          @fields[name] = field
        end
      end
    end
  end
end
