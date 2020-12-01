module NotificationsHelper
  def user_create_action(obj)
    if obj.source_type=='Reaction'
      obj.source.reactor
    else
      obj.source.user
    end
  end
  def item_info(obj)
    if obj.source_type=='Reaction'
      image_tag(link_by_icon(obj.source.icon_id), size: "20x20")
    else
      obj.source.content
    end
  end
end
