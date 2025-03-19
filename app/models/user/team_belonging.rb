# frozen_string_literal: true

class User
  module TeamBelonging
    extend ActiveSupport::Concern

    included do
      scope :in_team, ->(team) { Array.wrap(team).map { with_role("team-#{_1}") }.reduce(:or) }

      def team_lead_for
        roles.filter_map do |role|
          role.delete_prefix("team_lead-") if role.start_with?("team_lead-")
        end
      end

      def team_lead_of?(user)
        team_lead_for.intersect?(user.team_member_of)
      end

      def team_member_of
        roles.filter_map do |role|
          role.delete_prefix("team-") if role.start_with?("team-")
        end
      end
    end
  end
end
