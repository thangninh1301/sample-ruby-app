class ConversationsController < ApplicationController
  authorize_resource

  def create
    array = [current_user.id, strong_params[:received_id].to_i]
    @conversation = Conversation.find_by(members: array) || Conversation.find_by(members: array.reverse)
    @received = User.find(strong_params[:received_id])
    @conversation ||= Conversation.create(members: array)

    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  private

  def strong_params
    params.permit(:received_id)
  end
end
