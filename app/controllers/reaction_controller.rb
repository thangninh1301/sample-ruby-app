class ReactionController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    @reaction = Reaction.find_by(react_to_type: reaction_param[:react_to_type],
                                 react_to_id: reaction_param[:react_to_id],
                                 reactor_id: current_user.id).try(:destroy)
    @reaction = current_user.reactions.build(reaction_param)

    if @reaction.save
      @reaction.notifications.create(user_id: react_to_object.user_id)
    else
      @error = @reaction.errors.messages
    end
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

  def react_to_object
    if reaction_param[:react_to_type] == 'Micropost'
      @micropost = Micropost.find(reaction_param[:react_to_id])
    else
      @comment = Comment.find(reaction_param[:react_to_id])
    end
  end
end
