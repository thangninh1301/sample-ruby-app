class MessagesController < ApplicationController
  authorize_resource

  def create
    @message = current_user.messages.build(message_params)
    @conversation = Conversation.find_by(id: message_params[:conversation_id])
    if @message.save
      save_photo_if_exits
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

  def photo_params
    params.permit(photo: [])
  end

  def save_photo_if_exits
    return unless photo_params[:photo]

    photo_params[:photo].each do |a|
      photo = @message.photos.new(photo: a)
      @error = photo.errors.messages unless photo.save
    end
  end
end
