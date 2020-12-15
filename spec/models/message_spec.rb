require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:user_mike) { create(:user_mike) }
  let!(:another_user) { create(:another_user) }
  let!(:conversation) { Conversation.create(members: [user_mike.id, another_user.id]) }
  let(:message) { user_mike.messages.build(content: 'test string', conversation_id: conversation.id) }

  it 'should valid' do
    expect(message.valid?).to eq(true)
  end

  it 'should not valid with nil conversation_id' do
    message.conversation_id = nil
    expect(message.valid?).to eq(false)
  end

  it 'should not valid with blank content' do
    message.content = ''
    expect(message.valid?).to eq(false)
  end
end
