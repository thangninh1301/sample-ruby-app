require 'rails_helper'

RSpec.describe MessagesBroadcastJob, type: :job do
  include ActiveJob::TestHelper
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:conversation) { Conversation.create(members: [user_mike.id, another_user.id]) }
  let!(:message) { user_mike.messages.create(content: 'test string', conversation_id: conversation.id) }

  context 'with private method' do
    it 'should return render messages' do
      expect(MessagesBroadcastJob.new.send(:render_message, message, another_user.id)).to include('test string')
    end

    it 'should return render of box messages ' do
      expect(MessagesBroadcastJob.new.send(:render_box, conversation.id,
                                           another_user.id,
                                           user_mike)).to include('test string')
    end
  end
end
