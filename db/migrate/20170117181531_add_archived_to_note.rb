class AddArchivedToNote < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :archived, :boolean, default: false, index: true
    add_column :notes, :archived_at, :datetime
  end
end
