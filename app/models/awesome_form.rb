# frozen_string_literal: true

class AwesomeForm < ActionView::Helpers::FormBuilder
  def input(method, as: nil, placeholder: nil, required: nil, collection: nil, id_method: nil, name_method: nil,
    min: nil, step: nil)
    as ||= guess_type(method)
    options = {class: "input__input"}
    collection_based = !collection.nil? || as == :select
    collection ||= guess_collection(method) if collection_based
    name_method ||= guess_name_method(method) if collection_based
    id_method ||= :id if collection_based
    classes = []
    options[:placeholder] = placeholder if placeholder.present?
    options[:required] = true if required == true || (required.nil? && required_attributes.include?(method))
    options[:min] = min if min
    options[:step] = step if step
    input = render_input(method:, type: as, options:, id_method:, collection:,
      name_method:)
    wrap method:, content: input, classes: classes + ["input--#{as}"], label: nil
  end

  private

  def required_attributes
    []
  end

  def guess_type(method)
    return :select if method.to_s.end_with?("_id")
    return :datetime if method.to_s.end_with?("at")
    return :pdf if method.to_s.end_with?("pdf")
    return :password if method.to_s.include?("password")

    :string
  end

  def guess_collection(method)
    association_for(method)&.klass&.all || enum_for(method).map { |e| OpenStruct.new(id: e, name: e) } || []
  end

  def guess_name_method(method)
    klass = association_for(method)&.klass
    return :name unless klass

    [:display_name, :name, :title].each do |key|
      return key if klass.instance_methods.include?(key)
    end
  end

  def association_for(method)
    collection_method = method.to_s.delete_suffix("_id")
    object.class.reflect_on_association(collection_method) if object.respond_to?(collection_method)
  end

  def enum_for(method)
    object.class.types.keys if object.class.respond_to?(method.to_s.pluralize)
  end

  def render_input(method:, type:, collection:, id_method:, name_method:, options: {})
    case type
    when :string
      text_field method, options
    when :text
      text_area method, options
    when :password
      password_field method, options
    when :number
      number_field method, options
    when :date
      date_field method, options
    when :datetime
      datetime_local_field method, options
    when :pdf
      file_field method, options.reverse_merge(accept: "application/pdf")
    when :select
      collection_select method, collection, id_method, name_method
    end
  end

  def wrap(method:, content:, classes:, label:)
    if object&.errors&.[](method)&.any?
      classes << "input--error"
      errors = safe_join(object.errors[method].map { |e| content_tag :div, e, class: "input__error" })
    end
    label = (label == false) ? nil : self.label(method, label, class: "input__label")
    content_tag(:div, safe_join([label, content, errors].compact), class: ["input"] + classes)
  end

  def helper
    @template
  end

  delegate :content_tag, :t, :safe_join, :icon, :tag, to: :helper
end
