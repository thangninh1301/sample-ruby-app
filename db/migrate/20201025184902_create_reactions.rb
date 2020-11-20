class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.integer :icon_id
      t.integer :reactor_id
      t.integer :react_to_id
      t.string :react_to_type
      t.timestamps
    end
    add_index :reactions, :react_to_type
    add_index :reactions, :react_to_id
    add_index :reactions, :reactor_id
    add_index :reactions,[:icon_id,
                          :reactor_id,
                          :react_to_type,
                          :react_to_id],
              unique: true,
              name: "reaction_index_unique"
  end
end
