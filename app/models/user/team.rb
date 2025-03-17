# frozen_string_literal: true

class User
  module Team
    extend ActiveSupport::Concern

    included do
      scope :in_team, ->(team) { with_role "team-#{team}" }

      def team_lead_for
        roles.filter_map do |role|
          role.delete_prefix("team-lead-") if role.start_with?("team-lead-")
        end
      end

      def team_member_of
        roles.filter_map do |role|
          role.delete_prefix("team-") if role.start_with?("team-") && !role.start_with?("team-lead-")
        end
      end
    end
  end
end
