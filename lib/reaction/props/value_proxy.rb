module Reaction
  module Props
    class ValueProxy < SimpleDelegator
      def initialize(value, context:)
        super(value)
        value.instance_variables.each do |name|
          instance_variable_set(name, value.instance_variable_get(name))
        end
        @context = context
      end

      def helpers
        @context
      end

      def root(&block)
        @context.instance_eval(&block)
      end
    end
  end
end
