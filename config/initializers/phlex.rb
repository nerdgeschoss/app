# frozen_string_literal: true

module Views
end

module Components
  extend Phlex::Kit
end

# Reaction props files are schema DSL scripts, not Ruby classes — keep them out of Zeitwerk.
Rails.autoloaders.main.ignore(Rails.root.join("app/views/**/*.props.rb").to_s)

Rails.autoloaders.main.push_dir(
  Rails.root.join("app/views"), namespace: Views
)

Rails.autoloaders.main.push_dir(
  Rails.root.join("app/components"), namespace: Components
)

# Components live in one folder per component (stack/stack.rb + stack/stack.scss),
# so the folder does not add a namespace: app/components/stack/stack.rb => Components::Stack.
Rails.autoloaders.main.collapse(Rails.root.join("app/components/*").to_s)
