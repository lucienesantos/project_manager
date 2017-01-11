class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.datetime :conclusion_at, null: false
      t.string :state, default: "started"
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
