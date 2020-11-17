class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :micropost_id
      t.integer :parent_comment_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :comments, %i[user_id created_at]
  end
end
