class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  after_create :create_notification, :send_mail

  def create_notification
    NotificationBroadcastJob.perform_later(self, user_id)
  end

  def send_mail
    UserMailer.notification(self).deliver_later
  end
end
