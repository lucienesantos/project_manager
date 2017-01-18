class AddArchivedToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :archived, :boolean, default: false, index: true
    add_column :projects, :archived_at, :datetime
  end
end
