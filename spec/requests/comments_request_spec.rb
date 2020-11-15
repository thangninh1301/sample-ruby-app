require 'rails_helper'

describe CommentsController, type: :controller do
  before(:each) do
    @user_mike = create(:user_mike)
    @micropost = @user_mike.microposts.create(content: 'Lorem ipsum')
    @save_cmt = @user_mike.comments.create(content: 'Lorem ipsum', micropost_id: @micropost.id)
  end

  # it 'should ' do
  #   session[:user_id] = @user_mike.id
  #   post :create, params: { icon_id: 2, micropost_id: @micropost.id }
  #   expect(Reaction.last.micropost_id).to eq(@micropost.id)
  # end

  it 'should success create new cmt' do
    session[:user_id] = @user_mike.id
    post :create, params: { content: 'this is test string', micropost_id: @micropost.id }
    expect(Comment.last.content).to eq('this is test string')
  end

  it 'should success del cmt' do
    session[:user_id] = @user_mike.id
    post :destroy, params: { id: @save_cmt.id }
    expect(@user_mike.comments.count).to eq(0)
  end

  it 'should not save cmt when not logged in' do
    save = Comment.count
    post :create, params: { content: 'this is test string', micropost_id: @micropost.id }
    expect(Comment.count).to eq(save)
  end
end
