# frozen_string_literal: true

class AddShapingNotesAndQaNotesToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :shaping_notes, :text, null: true
    add_column :tasks, :qa_notes, :text, null: true
  end
end
