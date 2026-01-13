# frozen_string_literal: true

module PolicyEnforcing
  extend ActiveSupport::Concern

  included do
    def policy(name, user: current_user)
      Pundit.policy!(user, name)
    end

    def raise_auth_error(object, method = field.method_sym)
      extensions = {object: object.class.name}
      extensions[:id] = object.id if object.respond_to?(:id)
      raise GraphQL::ExecutionError.new(
        "Not authorized to #{method.to_s.humanize(capitalize: false)}",
        extensions:
      )
    end

    def authorize(object, method = field.method_sym)
      raise_auth_error(object, method) unless policy(object).public_send("#{method}?")

      object
    end

    def policy_scope(scope)
      Pundit.policy_scope!(current_user, scope)
    end
  end
end
