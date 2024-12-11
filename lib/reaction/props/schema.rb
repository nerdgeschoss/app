module Reaction
  module Props
    class Schema
      Boolean = Field::Boolean
      attr_reader :root, :context

      def initialize(string)
        @root = Field.new(:root, Object, null: false, parent: self)
        @root.instance_exec { binding.eval(string) }
      end

      def serialize(object)
        @context = object
        root.serialize(object).deep_transform_keys { _1.to_s.camelize(:lower) }
      end

      def path
        ""
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
