require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let!(:save_cmt) { user_mike.comments.create(content: 'Lorem ipsum', micropost_id: micropost.id) }

  context 'when user is logged in' do
    before(:each) do
      session[:user_id] = user_mike.id
    end
    it 'should success create new cmt' do
      expect do
        post :create, xhr: true, params: { content: 'this is test string', micropost_id: micropost }
      end
        .to change(Comment, :count).by(1)
      expect(Comment.last.content).to eq('this is test string')
      expect(response).to render_template('comments/create')
    end

    it 'should success del cmt' do
      expect do
        post :destroy, xhr: true, params: { id: save_cmt.id }
      end
        .to change(Comment, :count).by eq(-1)
      expect(response).to render_template('comments/destroy')
    end

    it 'should not success create new cmt with invalid parasm' do
      expect do
        post :create, xhr: true, params: { content: 'a' * 150, micropost_id: micropost }
      end
        .to change(Comment, :count).by(0)
      expect(response).to render_template('comments/create')
      expect(assigns(:error)).to include(content: ['is too long (maximum is 140 characters)'])
    end
  end
  context 'when user not logged in' do
    it 'should not save cmt when not logged in' do
      expect do
        post :create, xhr: true, params: { content: 'this is test string', micropost_id: micropost }
      end
        .to change(Comment, :count).by(0)
      expect(response).to redirect_to login_url
    end

    it 'should not delete cmt when not logged in' do
      expect do
        post :destroy, xhr: true, params: { id: save_cmt.id }
      end
        .to change(Comment, :count).by(0)
      expect(response).to redirect_to login_url
    end
  end
end
