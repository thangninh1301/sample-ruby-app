# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def notification
    notification = Notification.first
    UserMailer.notification(notification)
  end
end
