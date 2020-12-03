class UserMailer < ApplicationMailer
  include NotificationsHelper
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def notification(notification)
    @notification = notification
    @user_create_action = user_create_action(notification)
    mail to: notification.user.email, subject: 'Notification'
  end
end
