require 'rails_helper'

RSpec.describe NotificationsChannel, type: :channel do
  include ActionCable::TestHelper
  let!(:user) { create(:user_mike) }

  context 'when user is logged in and subscribe' do
    before do
      stub_connection current_user: user
      subscribe
    end
    it 'should success' do
      expect(subscription.streams).to include("user_notification_#{user.id}")
    end

    it 'should success send data' do
      ActionCable.server.broadcast "user_notification_#{user.id}", text: 'hello'
      expect(broadcasts("user_notification_#{user.id}")).to include('{"text":"hello"}')
    end

    it 'should success send data' do
      ActionCable.server.broadcast "user_notification_#{user.id}", text: 'hello'
      expect(broadcasts("user_notification_#{user.id}")).to include('{"text":"hello"}')
    end
  end

  context 'when user is not logged in' do
    before do
      stub_connection current_user: nil
    end
    it 'should not subscribe' do
      subscribe
      expect(subscription.streams.count).to eq(0)
    end
  end
end
