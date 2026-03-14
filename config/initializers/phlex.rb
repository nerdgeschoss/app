# frozen_string_literal: true

module Views
end

module Components
  extend Phlex::Kit
end

Rails.autoloaders.main.push_dir(
  Rails.root.join("app/views"), namespace: Views
)

Rails.autoloaders.main.push_dir(
  Rails.root.join("app/components"), namespace: Components
)

Rails.autoloaders.main.collapse(Rails.root.join("app/components/*"))

# Ignore Reaction .props.rb and .tsx files managed by the TSX handler while we are transitioning
Rails.autoloaders.main.ignore(Rails.root.join("app/views/**/*.props.rb"))
Rails.autoloaders.main.ignore(Rails.root.join("app/views/**/*.tsx"))
