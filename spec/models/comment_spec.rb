require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:comment) { micropost.comments.new(user_id: user_mike.id, content: 'test content') }

  it '@comment should valid' do
    expect(comment.valid?).to eq(true)
  end

  it 'blank content should invalid' do
    comment.content = ''
    expect(comment.valid?).to eq(false)
  end

  it '@@comment with both micropost_id and super_cmt_id are nil shoud invalid' do
    comment.micropost_id = nil
    expect(comment.valid?).to eq(false)
  end

  it '@@comment with both micropost_id and super_cmt_id are not nil shoud invalid' do
    comment.save
    cmt_test = Comment.new(user_id: user_mike.id, content: 'test content')
    cmt_test.parent_comment_id = comment
    cmt_test.micropost_id = micropost
    expect(cmt_test.valid?).to eq(false)
  end

  it 'should return true if nil micropost' do
    comment.micropost_id = nil
    expect(comment.nil_micropost?).to eq(true)
  end

  it 'should return false if not nil micropost' do
    expect(comment.nil_micropost?).to eq(false)
  end

  it 'should return true if nil_super_comment?' do
    expect(comment.nil_super_comment?).to eq(true)
  end

  it 'should return false if not nil_super_comment?' do
    comment.parent_comment_id = 1
    expect(comment.nil_super_comment?).to eq(false)
  end

  it 'replies should not have reply' do
    comment.save
    comment_f2 = comment.replies.create(content: 'Lorem ipsum', user_id: user_mike.id, micropost_id: micropost.id)
    comment_f3 = comment_f2.replies.create(content: 'Lorem ipsum', user_id: user_mike.id, micropost_id: micropost.id)
    expect(comment_f3.valid?).to eq(false)
  end
end
