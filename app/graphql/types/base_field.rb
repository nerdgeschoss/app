# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    include PolicyEnforcing

    argument_class Types::BaseArgument

    attr_reader :required_permission

    def initialize(*args, required_permission: nil, **kwargs, &block)
      @required_permission = required_permission
      super(*args, **kwargs, &block)
    end

    def authorized?(obj, arg_value, ctx)
      super && if required_permission
                 policy(obj, user: ctx[:current_user]).public_send("#{required_permission}?")
               else
                 true
               end
    end
  end
end
