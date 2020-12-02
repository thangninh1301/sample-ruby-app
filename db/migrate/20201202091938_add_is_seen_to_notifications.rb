class AddIsSeenToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :is_seen, :boolean, default: :false
  end
end
