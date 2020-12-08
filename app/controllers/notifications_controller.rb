class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: %i[update show]
  load_and_authorize_resource

  def update
    @notification.update(is_seen: true)
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  def show
    @notification.update(is_seen: true)
    return redirect_to @notification.source.react_to.micropost.user if @notification.source_type == 'Reaction'

    redirect_to @notification.source.micropost.user
  end
end
