# frozen_string_literal: true

Yael::Bus.shared.routing do
  # dispatch :order_confirmed, to: "order_mailer#confirm", queue: :low_priority
end
