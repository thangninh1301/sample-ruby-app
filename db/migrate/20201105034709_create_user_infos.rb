class CreateUserInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :user_infos do |t|
      t.string :name
      t.string :avatar_url
      t.string :email
      t.string :provider
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
