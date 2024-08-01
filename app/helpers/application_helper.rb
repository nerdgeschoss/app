# frozen_string_literal: true

module ApplicationHelper
  include Shimmer::FileHelper

  def markdown(text)
    return nil if text.blank?

    options = {
      filter_html: true,
      no_images: true,
      no_links: true,
      hard_wrap: true,
      link_attributes: {rel: "nofollow", target: "_blank"},
      space_after_headers: true,
      fenced_code_blocks: false
    }
    extensions = {
      no_intra_emphasis: true,
      strikethrough: true,
      highlight: true,
      disable_indented_code_blocks: true
    }
    renderer = ::Redcarpet::Render::HTML.new(options)
    markdown = ::Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe # rubocop:disable Rails/OutputSafety
  end
end
