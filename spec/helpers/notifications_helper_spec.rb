require 'rails_helper'

RSpec.describe NotificationsHelper, type: :helper do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:another_user) {create(:another_user)}
  let(:comment) { micropost.comments.create(user_id: another_user.id, content: 'test content') }
  let!(:notification) { comment.notifications.create(user_id: micropost.user_id) }

  it "should return another_user who created comment" do
    expect(user_create_action(notification)).to eq(another_user)
  end

  it "should return comment content" do
    expect(item_info(notification)).to eq(comment.content)
  end
end
