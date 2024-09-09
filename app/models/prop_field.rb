class PropField
  attr_reader :name, :type, :null, :fields

  def initialize(name, type = nil, null: true, &block)
    @name = name
    @type = block ? Object : type
    @null = null
    @fields = {}
    instance_exec(&block) if block
  end

  def serialize(value)
    return nil if value.nil? && null

    if type.nil?
      value
    elsif type == String
      value.to_s
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
        field_value = value.is_a?(Hash) ? value.with_indifferent_access[name] : value.try(name)
        [name, field.serialize(field_value)]
      end.to_h
    else
      raise "Unknown type: #{type}"
    end
  end

  def to_typescript(skip_root: false)
    name = self.name.to_s.camelize(:lower)
    if type.nil?
      "#{name}: unknown#{null ? " | null" : ""};"
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

  def field(name, type = nil, null: true, &)
    @fields[name] = PropField.new(name, type, null:, &)
  end
end
