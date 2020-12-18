require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:valid_image) do
    Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/app/assets/images/icons/message.jpg')),
                                 'image/jpg')
  end

  let(:invalid_file_type) do
    Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/app/assets/images/icons/message.jpg')))
  end

  let(:invalid_file_extra) do
    Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/app/assets/images/rails.svg')),
                                 'image/jpg')
  end

  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let(:conversation) do
    Conversation.create(sender_id: user_mike.id,
                        receiver_id: another_user.id)
  end
  let(:message) { user_mike.messages.create(content: 'test string', conversation_id: conversation.id) }
  let(:blank_photo) { Photo.new }

  it 'should invalid with nil photo' do
    expect(blank_photo.valid?).to eq(false)
    expect(blank_photo.errors.messages[:photo].first).to include("can't be blank")
  end

  context 'with invalid_file_type image' do
    let(:photo) { message.photos.build(photo: valid_image) }
    it 'should valid' do
      expect(photo.valid?).to eq(true)
    end
  end

  context 'with invalid file type image' do
    let(:photo) { message.photos.build(photo: invalid_file_type) }
    it 'should valid' do
      expect(photo.valid?).to eq(false)
      expect(photo.errors.messages[:photo].first).to include('allowed types: (?-mix:image')
    end
  end

  context 'with invalid file name extra image' do
    let(:photo) { message.photos.build(photo: invalid_file_extra) }
    it 'should valid' do
      expect(photo.valid?).to eq(false)
      expect(photo.errors.messages[:photo].first).to include('allowed types: jpg, jpeg, gif, png')
    end
  end
end
