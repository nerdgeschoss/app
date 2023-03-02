# frozen_string_literal: true

class ComponentRegistry
  class SlotCapturer
    attr_reader :locals

    def initialize(context)
      @context = context
      @locals = {}
    end

    def method_missing(name, &block)
      @locals[name.to_sym] = capture(&block)
    end

    def respond_to_missing?(_name)
      true
    end

    private

    attr_reader :context
    delegate :capture, to: :context
  end

  def initialize(context, &block)
    @context = context
    @components = {}
    block&.call(self)
  end

  def register(name, component = nil, tag: "div", &block)
    if view_component?(name)
      component = name
      name = component.name.underscore.delete_suffix("_component")
    end
    if view_component?(component)
      self.class.define_method name.to_s do |**locals, &block|
        cap = SlotCapturer.new(context)
        content = capture { block&.call(cap) }
        locals.merge! cap.locals
        locals[:content] = content if cap.locals.none?
        content = locals.delete(:content)
        instance = component.new(**locals)
        instance = instance.with_content(content) if content.present?
        capture { render(instance) }
      end
    elsif component.nil? && block.nil?
      self.class.define_method name.to_s do |variant = nil, &block|
        content = capture { block.call } if block
        classes = [name.to_s]
        classes.push "#{name}--#{variant}" if variant.present?
        content_tag tag, content, class: classes
      end
    elsif component.present? && component.is_a?(String)
      self.class.define_method name.to_s do |**locals, &block|
        cap = SlotCapturer.new(context)
        content = capture { block&.call(cap) }
        locals.merge! cap.locals
        locals[:content] = content if cap.locals.none?
        capture { render(partial: component, locals: locals) }
      end
    end
  end

  private

  attr_reader :context

  delegate :content_tag, :capture, :render, to: :context

  def view_component?(thing)
    base_class = "ViewComponent::Base".safe_constantize
    base_class && thing.is_a?(Class) && thing < base_class
  end
end
