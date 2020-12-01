class PushNotificationService
  def initialize(args = {})
    @notification = args[:notification]
    @current_user = notification.user
  end

  def perform
    ActionCable.server.broadcast "user_notification_#{notification.user.id}_channel", notification_attrs
  rescue StandardError
    nil
  end

  private

  attr_reader :notification, :current_user

  def render_notification
    ApplicationController.renderer.render partial: partial_html_path, locals: { notification: notification }
  end

  def notification_attrs
    {
      id: notification.id,
      message: render_notification,
      count: @current_user.notifications.seen(false).size,
      url: notification.display_url
    }
  end

  def partial_html_path
    'user/notifications/notification'
  end
end
