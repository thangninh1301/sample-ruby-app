require 'rails_helper'

describe ConversationsController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }

  context 'when user is logged in' do
    before(:each) do
      sign_in user_mike
    end
    it 'should success create new Conversation' do
      expect do
        post :create, xhr: true, params: { received_id: another_user.id }
      end
        .to change(Conversation, :count).by(1)
      expect(Conversation.last.members).to include(another_user.id)
      expect(Conversation.last.members).to include(user_mike.id)
    end
  end
  context 'when user is not logged in' do
    it 'should not success create new Conversation' do
      expect do
        post :create, xhr: true, params: { received_id: another_user.id }
      end
        .to change(Conversation, :count).by(0)
      expect(response.body).to include 'You need to sign in or sign up before continuing'
      expect(response.code).to eq('401')
    end
  end
end
