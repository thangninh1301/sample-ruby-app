require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }

  it 'micropost shoud valid' do
    expect(micropost.valid?).to eq(true)
  end

  it 'micropost shoud valid' do
    cmt = micropost.comments.create(user_id: user_mike.id, content: 'test content')
    cmt.replies.create(user_id: user_mike.id, content: 'test content', micropost_id: micropost.id)
    expect(micropost.comments.count).to eq(2)
    expect(micropost.f1_comments.count).to eq(1)
  end
end
