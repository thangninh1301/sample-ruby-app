# frozen_string_literal: true

module SessionsHelper
  # Returns true if the given user is the current user.
  def current_user?(user)
    user && user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
