require 'rails_helper'

describe MessagesController, type: :controller do
  include ActiveJob::TestHelper

  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:conversation) { Conversation.create(members: [user_mike.id, another_user.id]) }
  context 'when user is logged in' do
    before(:each) do
      sign_in user_mike
    end
    it 'should success create new message' do
      expect do
        post :create, xhr: true, params: { content: 'test content', received_id: another_user.id,
                                           conversation_id: conversation.id }
      end
        .to change(Message, :count).by(1)
      expect(Message.last.content).to eq('test content')
    end

    it 'should not create new message with invalid content' do
      expect do
        post :create, xhr: true, params: { content: '', received_id: another_user.id, conversation_id: conversation.id }
      end
        .to change(Message, :count).by(0)
      expect(assigns(:error)).to include(content: ["can't be blank"])
    end
  end
  context 'when user is not logged in' do
    it 'should not success create new Conversation' do
      expect do
        post :create, xhr: true, params: { content: 'test content', received_id: another_user.id,
                                           conversation_id: conversation.id }
      end
        .to change(Conversation, :count).by(0)
      expect(response.body).to include 'You need to sign in or sign up before continuing'
      expect(response.code).to eq('401')
    end
  end
end
