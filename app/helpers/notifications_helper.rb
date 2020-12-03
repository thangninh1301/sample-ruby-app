module NotificationsHelper
  def user_create_action(notification)
    if notification.source_type == 'Reaction'
      notification.source.reactor
    else
      notification.source.user
    end
  end

  def item_info(notification)
    if notification.source_type == 'Reaction'
      image_tag(link_by_icon(notification.source.icon_id), size: '20x20')
    else
      notification.source.content
    end
  end
end
