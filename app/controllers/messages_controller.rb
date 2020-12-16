class MessagesController < ApplicationController
  authorize_resource

  def create
    @message = current_user.messages.build(message_params)
    @conversation = Conversation.find_by(id: message_params[:conversation_id])
    if @message.save
      MessagesBroadcastJob.perform_now(@message, params[:receiver_id], message_params[:conversation_id], current_user)
    else
      @error = @message.errors.messages
    end
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  private

  def message_params
    params.permit(:conversation_id, :content)
  end
end
