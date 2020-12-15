class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.text :content
      t.timestamps
    end

    create_table :conversations do |t|
      t.timestamps
      t.string :members
    end


  end
end
