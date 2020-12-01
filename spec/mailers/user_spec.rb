require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:comment) { micropost.comments.create(user_id: user_mike.id, content: 'test content') }
  let(:notification) { comment.notifications.create(user_id: micropost.user_id) }
  let(:mail) { UserMailer.notification(notification) }

  it 'should return email' do
    expect(mail.to).to include(user_mike.email)
    expect(mail.body.encoded).to include(user_mike.name)
  end
end
