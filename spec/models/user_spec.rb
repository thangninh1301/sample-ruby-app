require 'rails_helper'

RSpec.describe User, type: :model do
  it 'user_without_password should be valid' do
    test=build(:user_without_password).valid?
    expect(test).to eq(true)
  end

end
