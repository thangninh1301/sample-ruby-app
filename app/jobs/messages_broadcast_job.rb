class MessagesBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, received_id, conversation_id, current_user)
    ActionCable.server.broadcast "user_conversation_#{received_id}", { conversation_id: conversation_id,
                                                                       sender_id: current_user.id,
                                                                       messages: render_message(message, received_id) }
  end

  private

  def render_message(message, received_id)
    received = User.find(received_id)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message,
                                                                                 current_user: received })
  end
end
