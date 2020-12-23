require 'rails_helper'

describe MessagesController, type: :controller do
  include ActiveJob::TestHelper

  let(:valid_image) do
    Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/app/assets/images/icons/message.jpg')),
                                 'image/jpg')
  end
  let(:invalid_file_type) do
    Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/app/assets/images/icons/message.jpg')))
  end
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:conversation) do
    Conversation.create(sender_id: user_mike.id,
                        receiver_id: another_user.id)
  end
  let!(:message) { user_mike.messages.create(conversation_id: conversation.id, content: 'test') }

  context 'with private controller method' do
    it 'should success create new message' do
      controller = MessagesController.new
      controller.instance_variable_set(:@message, message)
      controller.params = ActionController::Parameters.new({ photo: [valid_image] })
      expect do
        controller.send(:save_photo_if_exist)
      end
        .to change(Photo, :count).by(1)
    end
  end

  context 'when user is logged in' do
    before(:each) do
      sign_in user_mike
    end
    it 'should success create new message' do
      expect do
        post :create, xhr: true, params: { content: 'test content', receiver_id: another_user.id,
                                           conversation_id: conversation.id,
                                           photo: [] }
      end
        .to change(Message, :count).by(1)
      expect(Message.last.content).to eq('test content')
    end

    it 'should success create new message with photo' do
      expect do
        post :create, xhr: true, params: { content: 'test content', receiver_id: another_user.id,
                                           conversation_id: conversation.id,
                                           photo: [valid_image] }
      end
        .to change(Message, :count).by(1)
                                   .and change(Photo, :count).by(1)
      expect(Message.last.content).to eq('test content')
      expect(Message.last.photos.any?).to eq(true)
    end

    it 'should not create new message with invalid content' do
      expect do
        post :create, xhr: true, params: { content: '', receiver_id: another_user.id, conversation_id: conversation.id }
      end
        .to change(Message, :count).by(0)
      expect(assigns(:error)).to include(content: ["can't be blank"])
    end

    it 'should not return fail with invalid image' do
      expect do
        post :create, xhr: true, params: { content: 'test content', receiver_id: another_user.id,
                                           conversation_id: conversation.id,
                                           photo: [invalid_file_type] }
      end
        .to change(Photo, :count).by(0)
      expect(assigns(:error)[:photo].first).to include('allowed types: (?-mix:image')
    end
  end

  context 'when user is not logged in' do
    it 'should not success create new Conversation' do
      expect do
        post :create, xhr: true, params: { content: 'test content', receiver_id: another_user.id,
                                           conversation_id: conversation.id }
      end
        .to change(Conversation, :count).by(0)
      expect(response.body).to include 'You need to sign in or sign up before continuing'
      expect(response.code).to eq('401')
    end
  end
end
