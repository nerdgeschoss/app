# frozen_string_literal: true

class User
  module SshManaging
    extend ActiveSupport::Concern

    included do
      def ssh_key
        if attributes["ssh_key"].blank? && github_handle.present?
          key = Github.new.ssh_key_for_user_name(github_handle)
          update! ssh_key: key unless key.blank?
        end
        attributes["ssh_key"]
      end
    end
  end
end
