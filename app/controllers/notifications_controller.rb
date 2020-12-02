class NotificationsController < ApplicationController
  before_action :logged_in_user, only: %i[update show]
  before_action :correct_user, only: %i[update show]

  def update
    @notification.is_seen = true
    @notification.save
  end
  respond_to do |format|
    format.html { to_last_url }
    format.js {}
  end

  def show
    @notification.is_seen = true
    @notification.save
    redirect_to root_path
  end

  private

  def correct_user
    @notification = current_user.notifications.find_by(id: params[:id])
    redirect_to root_url if @notification.nil?
  end
end
