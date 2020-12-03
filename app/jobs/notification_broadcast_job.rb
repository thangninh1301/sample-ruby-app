class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification, user_id)
    ActionCable.server.broadcast "user_notification_#{user_id}", { counter: counter(user_id),
                                                                   notification: render_notification(notification) }
  end

  private

  def counter(user_id)
    User.find(user_id).notifications.count
  end

  def render_notification(notification)
    ApplicationController.renderer.render(partial: 'notifications/notification', locals: { notification: notification })
  end
end
