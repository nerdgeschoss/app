# frozen_string_literal: true

class Views::Base < Components::Base
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::TurboStreamFrom

  # The `Views::Base` is an abstract class for all your views.

  # By default, it inherits from `Components::Base`, but you
  # can change that to `Phlex::HTML` if you want to keep views and
  # components independent.

  # More caching options at https://www.phlex.fun/components/caching
  def cache_store = Rails.cache

  private

  # Broadcast refreshes re-fetch the page and morph it in place, keeping the scroll position.
  def refresh_by_morphing
    content_for(:additional_head_tags) do
      meta(name: "turbo-refresh-method", content: "morph")
      meta(name: "turbo-refresh-scroll", content: "preserve")
    end
  end
end
