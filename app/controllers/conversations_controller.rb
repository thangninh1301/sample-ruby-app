class ConversationsController < ApplicationController
  authorize_resource

  def create
    @conversation = Conversation.find_by(sender_id: conversation_param[:receiver_id],
                                         receiver_id: current_user.id) ||
                    Conversation.find_by(receiver_id: conversation_param[:receiver_id],
                                         sender_id: current_user.id)

    @receiver = User.find_by(id: conversation_param[:receiver_id])

    @conversation ||= Conversation.create(sender_id: current_user.id,
                                          receiver_id: conversation_param[:receiver_id])

    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  private

  def conversation_param
    params.permit(:receiver_id)
  end
end
