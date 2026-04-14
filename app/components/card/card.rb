# frozen_string_literal: true

class Components::Card < Components::Base
  prop :id, _Nilable(String), default: nil
  prop :icon, _Nilable(_Union(String, Phlex::HTML)), default: nil
  prop :title, _Nilable(String), default: nil
  prop :subtitle, _Nilable(_Union(String, Phlex::HTML)), default: nil
  prop :context, _Nilable(_Union(String, Phlex::HTML)), default: nil
  prop :href, _Nilable(String), default: nil
  prop :type, _Nilable(_Union(:"login-card")), default: nil
  prop :icon_size, Integer, default: 28
  prop :with_divider, _Boolean, default: false

  def view_template(&block)
    if @href
      a(id: @id, class: card_classes, href: @href) { card_content(&block) }
    else
      div(id: @id, class: card_classes) { card_content(&block) }
    end
  end

  private

  def card_content(&block)
    stack(size: 24) do
      render_header if has_header?
      div(class: "card__divider") if @with_divider
      div(class: "card__content", &block) if block
    end
  end

  def card_classes
    classes = ["card"]
    classes << "card--login" if @type == :"login-card"
    classes.join(" ")
  end

  def has_header?
    @title || @subtitle || @context || @icon
  end

  def render_header
    div(class: "card__header", style: "--icon-size: #{@icon_size}px") do
      div(class: "card__header-content") do
        div(class: "card__title") do
          if @icon
            div(class: "card__icon") do
              if @icon.is_a?(Phlex::HTML)
                render @icon
              else
                plain(@icon)
              end
            end
          end
          text(type: :"h5-bold", color: "label-heading-primary") { @title } if @title
        end
        if @subtitle.is_a?(Phlex::HTML)
          div(class: "card__subtitle") { render @subtitle }
        elsif @subtitle
          div(class: "card__subtitle") { plain(@subtitle) }
        end
      end
      if @context
        div(class: "card__context") do
          if @context.is_a?(Phlex::HTML)
            render @context
          else
            plain(@context)
          end
        end
      end
    end
  end
end
