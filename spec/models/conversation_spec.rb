require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let(:conversation) do
    Conversation.new(sender_id: user_mike.id,
                     receiver_id: another_user.id)
  end
  let(:reverse_conversation) do
    Conversation.new(sender_id: another_user.id,
                     receiver_id: user_mike.id)
  end

  it 'should valid' do
    expect(conversation.valid?).to eq(true)
  end
  context 'when saved dup_conversation' do
    let!(:dup_conversation_saved) do
      Conversation.create(sender_id: user_mike.id,
                          receiver_id: another_user.id)
    end

    it 'should not valid with existed member with reverse' do
      expect(reverse_conversation.save).to eq(false)
      expect(reverse_conversation.errors.messages[:discount]).to include('unique_revert_conversation')
    end
  end
end
