class ProjectStatusAndHarvestReferences < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :repository, :string
    add_column :projects, :archived, :boolean, default: false, null: false
    add_index :projects, :archived
    add_column :projects, :harvest_id, :bigint
    change_column_null :projects, :name, false, ""
    change_column_null :projects, :client_name, false, ""
    add_column :projects, :framework_versions, :jsonb, default: {}, null: false

    up_only do
      execute <<-SQL.squish
        UPDATE projects
        SET harvest_id = harvest_ids[1], repository = repositories[1]
      SQL
    end
  end
end
