module Reaction
  module Props
    class Field
      attr_reader :name, :type, :null, :fields, :value_override, :global, :array

      def initialize(name, type = String, null: false, value: nil, global: nil, array: false, &block)
        @name = name
        @type = block ? Object : type
        @null = null
        @value_override = value
        @fields = {}
        @global = global
        @array = array
        instance_exec(&block) if block
      end

      def serialize(value, array_content: false)
        return nil if value.nil? && null

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
          value.to_s
        elsif type == Time
          value.iso8601
        elsif type == Object
          fields.map do |name, field|
            field_value = if field.value_override
              value.instance_exec(&field.value_override)
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
          "#{name}: Array<{#{to_typescript(skip_root: true, array_content: true)}}>"
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

      private

      def field(name, type = String, null: false, value: nil, global: nil, array: false, &)
        @fields[name] = self.class.new(name, type, null:, value:, global:, array:, &)
      end
    end
  end
end
