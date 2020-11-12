require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @user_mike = create(:user_mike)
    @micropost = @user_mike.microposts.create(content: 'Lorem ipsum')
    @comment = @micropost.comments.new(user_id: @user_mike.id, content: 'test content')
  end

  it "@comment should valid" do
    expect(@comment.valid?).to eq(true)
  end

  it "blank content should invalid" do
    @comment.content=''
    expect(@comment.valid?).to eq(false )
  end

  it '@@comment with both micropost_id and super_cmt_id are nil shoud invalid' do
    @comment.micropost_id = nil
    expect(@comment.valid?).to eq(false)
  end

  it '@@comment with both micropost_id and super_cmt_id are not nil shoud invalid' do
    @comment.super_comment_id = 3
    expect(@comment.valid?).to eq(false)
  end


end
