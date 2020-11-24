require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let!(:comment) { micropost.comments.new(user_id: user_mike.id, content: 'test content') }

  it 'should valid' do
    expect(comment.valid?).to eq(true)
  end

  it 'should invalid with blank content' do
    comment.content = ''
    expect(comment.valid?).to eq(false)
  end

  it 'should invalid with nil micropost_id' do
    comment.micropost_id = nil
    expect(comment.valid?).to eq(false)
  end

  it 'should not have reply if cmt is replies' do
    comment.save
    comment_f2 = comment.replies.create(content: 'Lorem ipsum', user_id: user_mike.id, micropost_id: micropost.id)
    comment_f3 = comment_f2.replies.create(content: 'Lorem ipsum', user_id: user_mike.id, micropost_id: micropost.id)
    expect(comment_f3.valid?).to eq(false)
    expect(comment_f3.errors.messages[:discount]).to include('replies_should_not_have_reply')
  end
end
