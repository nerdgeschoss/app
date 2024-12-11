module Reaction
  module Props
    class ValueProxy < SimpleDelegator
      def initialize(value)
        super(value)
        value.instance_variables.each do |name|
          instance_variable_set(name, value.instance_variable_get(name))
        end
      end

      def helpers
        @helpers ||= ApplicationController.new.helpers
      end
    end
  end
end
