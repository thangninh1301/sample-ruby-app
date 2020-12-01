require 'rails_helper'

RSpec.describe NotificationBroadcastJob, type: :job do
  include ActiveJob::TestHelper
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:comment) { micropost.comments.create(user_id: user_mike.id, content: 'test content') }
  let!(:notification) { comment.notifications.create(user_id: micropost.user_id) }

  context 'with private method' do
    it 'should return number of notification' do
      expect(NotificationBroadcastJob.new.send(:counter, user_mike.id)).to eq(user_mike.notifications.count)
    end

    it 'should return render of notification ' do
      expect(NotificationBroadcastJob.new.send(:render_notification, notification)).to include(user_mike.name)
    end
  end
end
