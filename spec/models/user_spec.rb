require 'rails_helper'
require 'cancan/matchers'

describe User, type: :model do
  let!(:admin) { create(:user_mike) }
  let!(:another_user) { create(:another_user) }
  let(:admin_ability) { Ability.new(admin) }
  let(:another_user_ability) { Ability.new(another_user) }
  context 'with role' do
    it 'first user should be admin' do
      expect(admin.has_role?(:admin)).to eq(true)
      expect(admin).to eq(User.first)
    end

    it 'another_user user should not be admin' do
      expect(another_user.has_role?(:admin)).to eq(false)
    end
  end

  context 'with abilities' do
    it 'admin can edit all User' do
      expect(admin_ability).to be_able_to(:update, User.new)
      expect(admin_ability).to be_able_to(:destroy, User.new)
    end

    it 'another_user cannot edit all User' do
      expect(another_user_ability).to_not be_able_to(:update, User.new)
      expect(another_user_ability).to_not be_able_to(:destroy, User.new)
    end

    it 'another_user can edit their resource' do
      expect(another_user_ability).to be_able_to(:update, another_user.microposts.new)
      expect(another_user_ability).to be_able_to(:destroy, another_user.microposts.new)
      expect(another_user_ability).to be_able_to(:update, another_user.comments.new)
      expect(another_user_ability).to be_able_to(:destroy, another_user.comments.new)
      expect(another_user_ability).to be_able_to(:update, another_user.reactions.new)
      expect(another_user_ability).to be_able_to(:destroy, another_user.reactions.new)
    end

    it 'another_user cannot edit other resouce' do
      expect(another_user_ability).to_not be_able_to(:update, admin.microposts.new)
      expect(another_user_ability).to_not be_able_to(:destroy, admin.microposts.new)
      expect(another_user_ability).to_not be_able_to(:update, admin.comments.new)
      expect(another_user_ability).to_not be_able_to(:destroy, admin.comments.new)
      expect(another_user_ability).to_not be_able_to(:update, admin.reactions.new)
      expect(another_user_ability).to_not be_able_to(:destroy, admin.reactions.new)
    end

    #
    # expect(ability).to_not be_able_to(:destroy, Post.new)
  end
end
