require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let(:conversation) { Conversation.new(members: [user_mike.id, another_user.id]) }
  let(:reverse_conversation) { Conversation.new(members: [another_user.id, user_mike.id]) }

  it 'should valid' do
    expect(conversation.valid?).to eq(true)
  end
  context 'when saved dup_conversation' do
    let!(:dup_conversation_saved) { Conversation.create(members: [user_mike.id, another_user.id]) }

    it 'should not valid with existed member with reverse' do
      expect(reverse_conversation.save).to eq(false)
      expect(reverse_conversation.errors.messages[:discount]).to include('should unique members')
    end

    it 'should not valid with not unique data' do
      expect(conversation.save).to eq(false)
      expect(conversation.errors.messages[:discount]).to include('should unique members')
    end
  end
end
