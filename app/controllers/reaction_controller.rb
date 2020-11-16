class ReactionController < ApplicationController
  before_action :logged_in_user

  def create
    @reaction = Reaction.find_existed(current_user.id, reaction_param[:micropost_id]).first.try(:destroy)

    if reaction_param[:micropost_id]
      @micropost = Micropost.find(reaction_param[:micropost_id])
      @reaction = @micropost.reactions.build(reaction_param)
    else
      @comment = Comment.find(reaction_param[:comment_id])
      @reaction = @comment.reactions.build(reaction_param)
    end
    @reaction.reactor_id = current_user.id
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
    params.permit(:micropost_id, :icon_id, :id, :comment_id)
  end
end
