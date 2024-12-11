module Reaction
  module Props
    class Schema
      Boolean = Field::Boolean
      attr_reader :root

      def initialize(string)
        @root = Field.new(:root, Object, null: false)
        @root.instance_exec { binding.eval(string) }
      end

      def serialize(object)
        root.serialize(object).deep_transform_keys { _1.to_s.camelize(:lower) }
      end

      def to_typescript
        <<~TS
          export interface Props {
            #{root.to_typescript(skip_root: true)}
          }
        TS
      end
    end
  end
end
