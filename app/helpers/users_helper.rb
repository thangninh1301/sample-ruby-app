# frozen_string_literal: true

module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    size = options[:size]
    if user.avatar_url
      gravatar_url = user.avatar_url
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
    image_tag(gravatar_url, alt: user.name, class: 'gravatar', size: size.to_s+'x'+size.to_s)
  end
end
