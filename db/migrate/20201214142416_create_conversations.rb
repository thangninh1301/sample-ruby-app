class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.timestamps
      t.string :members
    end
  end
end
