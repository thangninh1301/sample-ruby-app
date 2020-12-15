require 'rails_helper'

RSpec.describe ConversationsChannel, type: :channel do
  include ActionCable::TestHelper

  let!(:user) { create(:user_mike) }
  let!(:another_user) { create(:another_user) }
  let!(:conversation) { Conversation.create(members: [user.id, another_user.id]) }
  let(:message) { another_user.messages.create(content: 'test string', conversation_id: conversation.id) }
  context 'when user is not logged in' do
    before do
      stub_connection current_user: nil
    end
    it 'should not subscribe' do
      expect { subscribe }
        .not_to change(Comment, :count)
    end
  end
  context 'when user is logged in and subscribe' do
    before do
      stub_connection current_user: user
      subscribe
    end
    it 'should success' do
      expect(subscription.streams).to include("user_conversation_#{user.id}")
    end

    it 'should success send data' do
      ActionCable.server.broadcast "user_conversation_#{user.id}", text: 'hello'
      expect(broadcasts("user_conversation_#{user.id}")).to include('{"text":"hello"}')
    end

    it 'should success return notification when use NotificationBroadcastJob' do
      MessagesBroadcastJob.perform_now(message, user.id, conversation.id, another_user)
      expect(broadcasts("user_conversation_#{user.id}").last).to include('conversation_id')
      expect(broadcasts("user_conversation_#{user.id}").last).to include('messages')
      expect(broadcasts("user_conversation_#{user.id}").last).to include('message-box-holder')
    end
  end
end
