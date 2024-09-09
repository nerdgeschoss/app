class PropSchema
  attr_reader :root

  def initialize(path)
    @root = PropField.new(:root, Object, null: false)
    @root.instance_exec { binding.eval(File.read(path)) }
  end

  def serialize(object)
    root.serialize(object)
  end

  def to_typescript
    <<~TS
      export interface Props {
        #{root.to_typescript(skip_root: true)}
      }
    TS
  end
end
