module ReactionHelper
  def link_by_icon(id)
    case id
    when 1
      'https://res.cloudinary.com/prvnbist/image/upload/v1492531171/XZOPuv9_eyqlr2.png'
    when 2
      'https://res.cloudinary.com/prvnbist/image/upload/v1492531172/uIjLl6R_cmbnqb.png'
    when 3
      'https://res.cloudinary.com/prvnbist/image/upload/v1492531177/lsHmtDy_ycqnbp.png'
    when 4
      'https://res.cloudinary.com/prvnbist/image/upload/v1492531177/s475u9d_o8trbg.png'
    when 5
      'https://res.cloudinary.com/prvnbist/image/upload/v1492531172/JJuD9qb_a7gkmu.png'
    when 6
      'https://res.cloudinary.com/prvnbist/image/upload/v1492531178/VDM3zOV_qy9fqj.png'
    else
      'icons/liked.png'
    end
  end

  def icon_to_text(comment)
    id = comment.get_reaction(current_user.id).icon_id if comment.get_reaction(current_user.id)
    case id
    when 1
      'like'
    when 2
      'tym'
    when 3
      'haha'
    when 4
      'wow'
    when 5
      'sad'
    when 6
      'angry'
    else
      'like'
    end
  end
end
