require 'rails_helper'

RSpec.describe Notification, type: :model do
  include ActiveJob::TestHelper

  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let!(:comment) { micropost.comments.create(user_id: user_mike.id, content: 'test content') }
  let(:notification) { comment.notifications.new(user_id: micropost.user_id) }

  it 'should valid notification' do
    expect(notification.valid?).to eq(true)
  end

  it 'should send an email' do
    expect do
      perform_enqueued_jobs do
        notification.save
      end
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
  end

  it 'should create NotificationBroadcastJob job and mailer job after save notification' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      notification.save
    end.to have_enqueued_job(NotificationBroadcastJob)
      .and have_enqueued_job(ActionMailer::MailDeliveryJob)
  end
end
