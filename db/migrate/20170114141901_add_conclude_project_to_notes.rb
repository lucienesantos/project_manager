class AddConcludeProjectToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :conclude_project, :integer
  end
end
