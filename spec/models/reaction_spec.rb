require 'rails_helper'

RSpec.describe Reaction, type: :model do
  before(:each) do
    @user_mike = create(:user_mike)
    @another_user = create(:another_user)
    @micropost = @user_mike.microposts.create(content: 'Lorem ipsum')
    @reaction = build(:reaction,reactor_id: @another_user.id,
                             micropost_id: @micropost.id,
                             icon_id: 1,
                             comment_id: nil)
  end

  it '@reaction shoud valid' do
    expect(@reaction.valid?).to eq(true)
  end

  it '@reaction with both micropost_id and cmt_id are nil shoud invalid' do
    @reaction.micropost_id = nil
    expect(@reaction.valid?).to eq(false)
  end

  it '@reaction with both micropost_id and cmt_id are !nil shoud invalid' do
    @reaction.comment_id = 2
    expect(@reaction.valid?).to eq(false)
  end

  it 'icon_id out range invalid' do
    @reaction.icon_id = 10
    expect(@reaction.valid?).to eq(false)
  end
end
