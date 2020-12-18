class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.integer :message_id
      t.string :photo

      t.timestamps
    end
  end
end
