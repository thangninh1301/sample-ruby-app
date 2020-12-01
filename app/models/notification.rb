class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  after_create_commit do
    NotificationBroadcastJob.perform_later(self, user_id)
  end
end
