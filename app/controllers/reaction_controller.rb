class ReactionController < ApplicationController
  before_action :logged_in_user

  def create
    @reaction = Reaction.find_existed(current_user.id, reaction_param[:micropost_id]).first.try(:destroy)
    @reaction = obj_reacted.reactions.build(reaction_param)
    @reaction.reactor_id = current_user.id
    @error = @comment.errors unless @reaction.save

    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  def destroy
    @micropost = Micropost.find(reaction_param[:micropost_id])
    @reaction = Reaction.find(reaction_param[:id])
    @reaction.destroy

    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  private

  def obj_reacted
    if reaction_param[:micropost_id]
      @micropost = Micropost.find(reaction_param[:micropost_id])
    else
      @comment = Comment.find(reaction_param[:comment_id])
    end
  end

  def reaction_param
    params.permit(:micropost_id, :icon_id, :id, :comment_id)
  end
end
