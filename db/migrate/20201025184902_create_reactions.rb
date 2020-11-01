class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.integer :icon_id
      t.integer :reactor_id
      t.integer :micropost_id

      t.timestamps
    end
    add_index :reactions, :micropost_id
    add_index :reactions, :reactor_id
    add_index :reactions, %i[icon_id reactor_id micropost_id], unique: true
  end
end
