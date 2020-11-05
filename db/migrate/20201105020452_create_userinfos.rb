class CreateUserinfos < ActiveRecord::Migration[6.0]
  def change
    create_table :userinfos do |t|
      t.string :name
      t.string :email
      t.string :avatar_url
      t.string :datafrom
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
