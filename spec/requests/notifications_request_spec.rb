require 'rails_helper'

describe NotificationsController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:comment) { micropost.comments.create(user_id: user_mike.id, content: 'test content') }
  let!(:notification) { comment.notifications.create(user_id: micropost.user_id) }
  context 'when user is logged in' do
    before(:each) do
      sign_in user_mike
    end
    it 'should change notification.is_seen' do
      expect do
        patch :update, xhr: true, params: { id: Notification.first }
      end
        .to change { Notification.first.is_seen }.from(false).to(true)
      expect(response).to render_template('notifications/update')
    end

    it 'should change notification.is_seen' do
      expect do
        get :show, params: { id: Notification.first }
      end
        .to change { Notification.first.is_seen }.from(false).to(true)
      expect(response).to redirect_to(user_mike)
    end
  end

  context 'when not logged in' do
    it 'should not change notification' do
      expect do
        get :show, params: { id: Notification.first }
      end
        .to_not change { Notification.first.is_seen }.from(false)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not change notification' do
      expect do
        patch :update, xhr: true, params: { id: Notification.first }
      end
        .to_not change { Notification.first.is_seen }.from(false)
      expect(response.body).to include 'You need to sign in or sign up before continuing'
      expect(response.code).to eq('401')
    end
  end

  context 'when logged in with another user' do
    before(:each) do
      sign_out user_mike
      sign_in another_user
    end

    it 'should not change notification' do
      expect do
        get :show, params: { id: Notification.first }
      end
        .to_not change { Notification.first.is_seen }.from(false)
      expect(response).to redirect_to root_url
      expect(flash[:alert]).to be_present
    end

    it 'should not change notification' do
      expect do
        patch :update, xhr: true, params: { id: Notification.first }
      end
        .to_not change { Notification.first.is_seen }.from(false)
      expect(response).to redirect_to root_url
      expect(flash[:alert]).to be_present
    end
  end
end
