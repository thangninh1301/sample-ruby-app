class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :source_id
      t.string :source_type
      t.boolean :is_seen, default: :false

      t.timestamps
    end
    add_index :notifications, :source_id
    add_index :notifications, :source_type
  end
end
