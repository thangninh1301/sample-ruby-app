require 'rails_helper'

RSpec.describe MessagesBroadcastJob, type: :job do
  include ActiveJob::TestHelper
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:conversation) do
    Conversation.create(sender_id: user_mike.id,
                        receiver_id: another_user.id)
  end
  let!(:message) { user_mike.messages.create(content: 'test string', conversation_id: conversation.id) }

  context 'with private method' do
    it 'should return render messages' do
      expect(MessagesBroadcastJob.new.send(:render_message, message, another_user.id)).to include('test string')
    end
  end
end
