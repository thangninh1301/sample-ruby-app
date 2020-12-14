class MessagesController < ApplicationController
  def create
    @message = current_user.messages.build(strong_params)
    if @message.save
      MessagesBroadcastJob.perform_later(@message, params[:received_id], strong_params[:conversation_id], current_user)
    end
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  private

  def strong_params
    params.permit(:conversation_id, :content)
  end
end
