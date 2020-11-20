class ReactionController < ApplicationController
  before_action :logged_in_user

  def create
    @reaction = Reaction.find_existed(@current_user.id, reaction_param[:react_to_type], reaction_param[:react_to_id]).first.try(:destroy)
    if reaction_param[:react_to_type] == 'Micropost'
      @micropost = Micropost.find(reaction_param[:react_to_id])
    else
      @comment = Comment.find(reaction_param[:react_to_id])
    end
    @reaction = @current_user.reactions.build(reaction_param)
    @error = @reaction.errors.messages unless @reaction.save

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

  def reaction_param
    params.permit(:micropost_id, :icon_id, :id, :comment_id, :react_to_id, :react_to_type)
  end
end
