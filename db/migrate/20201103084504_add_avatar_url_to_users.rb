class AddAvatarUrlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avatar_from, :string
  end
end
