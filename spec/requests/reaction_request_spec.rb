require 'rails_helper'
include ApplicationHelper

describe ReactionController, type: :controller do
  before(:each) do
    routes { Reaction::Engine.routes }
    @user_mike = create(:user_mike)
    @micropost = @user_mike.microposts.create(content: 'Lorem ipsum')
    @reaction = build(:reaction, reactor_id: @user_mike.id,
                                 micropost_id: @micropost.id,
                                 icon_id: 1,
                                 comment_id: nil)
  end
  it 'should return reaction id in model' do
    session[:user_id] = @user_mike.id
    post :create, params: { icon_id: 2, micropost_id: @micropost.id }
    expect(Reaction.last.micropost_id).to eq(@micropost.id)
  end

  it 'should update reaction icon_id' do
    session[:user_id] = @user_mike.id
    @reaction.save
    expect(Reaction.last.icon_id).to eq(1)
    post :create, params: { icon_id: 2, micropost_id: @micropost.id }
    expect(Reaction.last.icon_id).to eq(2)
  end

  it 'should delete reaction' do
    session[:user_id] = @user_mike.id
    @reaction.save
    save_id = @reaction.id
    post :destroy, params: { id: @reaction.id, micropost_id: @micropost.id }
    expect(Reaction.where(id: save_id).count).to eq(0)
  end
end
