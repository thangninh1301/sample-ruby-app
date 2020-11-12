require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before(:each) do
    @user_mike = create(:user_mike)
    @micropost = @user_mike.microposts.build(content: 'Lorem ipsum')
  end
  it 'micropost shoud valid' do
    expect(@micropost.valid?).to eq(true)
  end
end
