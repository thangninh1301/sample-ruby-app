class ReactionController < ApplicationController
  before_action :logged_in_user

  def create
    @reaction = Reaction.new(icon_id: reaction_param[:icon_id],
                             reactor_id: current_user.id,
                             micropost_id: reaction_param[:micropost_id])
    @micropost = Micropost.find(reaction_param[:micropost_id])
    return unless @reaction.save

    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  def destroy
    @micropost = Micropost.find(reaction_param[:micropost_id])
    @reaction = Reaction.find(reaction_param[:id])
    return unless @reaction.destroy

    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  private

  def reaction_param
    params.permit(:micropost_id, :icon_id, :id)
  end

  def to_last_url
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end
end
