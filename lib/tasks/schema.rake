# frozen_string_literal: true

namespace :schema do
  desc "writes the schema"
  task generate: :environment do
    schemas = {}
    Dir.glob(Rails.root.join("app", "views", "**", "*.props.rb")).each do |path|
      name = Pathname.new(path).relative_path_from(Rails.root.join("app", "views")).to_s.sub(".props.rb", "")
      schema = Reaction::Props::Schema.new(File.read(path))
      schemas[name] = schema.root.to_typescript(skip_root: true)
    end
    content = <<~TS
      export interface DataSchema {
        #{schemas.map { |name, schema| "\"#{name}\": {#{schema}}" }.join("\n")}
      }

      export type PageProps<T extends keyof DataSchema> = { data: DataSchema[T] };
    TS
    schema_path = Rails.root.join("data.d.ts")
    File.write(schema_path, content)
    sh "yarn prettier --write #{schema_path}"
  end
end
