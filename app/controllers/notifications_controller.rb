class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: %i[update show]
  before_action :correct_user, only: %i[update show]

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

  private

  def correct_user
    @notification = current_user.notifications.find_by(id: params[:id])
    redirect_to root_url if @notification.nil?
  end
end
