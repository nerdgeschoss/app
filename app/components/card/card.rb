# frozen_string_literal: true

class Components::Card < Components::Base
  prop :id, _Nilable(String)
  prop :href, _Nilable(String)
  prop :title, _Nilable(String)
  prop :icon, _Nilable(Proc)
  prop :subtitle, _Nilable(Proc)
  prop :context, _Nilable(Proc)
  prop :icon_size, Integer, default: 28
  prop :with_divider, _Boolean, default: false

  def view_template(&block)
    if @href
      a(id: @id, class: "card", href: @href) { inner(&block) }
    else
      div(id: @id, class: "card") { inner(&block) }
    end
  end

  private

  def inner(&block)
    stack(size: 24) do
      card_header if @title || @subtitle || @context || @icon
      div(class: "card__divider") if @with_divider
      div(class: "card__content", &block) if block
    end
  end

  def card_header
    div(class: "card__header", style: "--icon-size: #{@icon_size}px;") do
      div(class: "card__header-content") do
        div(class: "card__title") do
          div(class: "card__icon") { @icon.call } if @icon
          text(type: "h5-bold", color: "label-heading-primary") { @title }
        end
        div(class: "card__subtitle") { @subtitle.call } if @subtitle
      end
      div(class: "card__context") { @context.call } if @context
    end
  end
end
