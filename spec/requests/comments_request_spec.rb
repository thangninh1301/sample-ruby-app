require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:save_cmt) { user_mike.comments.create(content: 'Lorem ipsum', micropost_id: micropost.id) }
  let(:save) { Comment.count }

  context 'is logged in' do
    before(:each) do
      session[:user_id] = user_mike.id
    end
    it 'should success create new cmt' do
      redirect_to root_path
      post :create, xhr: true, params: { content: 'this is test string', micropost_id: micropost }
      expect(Comment.last.content).to eq('this is test string')
      expect(response.code).to eq('200')
      expect(response).to render_template('comments/create')
    end

    it 'should success del cmt' do
      post :destroy, xhr: true, params: { id: save_cmt.id }
      expect(user_mike.comments.count).to eq(0)
      expect(response).to render_template('comments/destroy')
    end

    it 'should not success create new cmt without invalid parasm' do
      post :create, xhr: true, params: { contents: 'this is test string', micropost_id: micropost }
      expect(Comment.count).to eq(save)
    end

    it 'should not success create new cmt without invalid parasm' do
      post :create, xhr: true, params: { content: '', micropost_id: micropost }
      expect(Comment.count).to eq(save)
    end
  end

  it 'should not save cmt when not logged in', skip_before: true do
    post :create, params: { content: 'this is test string', micropost_id: micropost.id }
    expect(Comment.count).to eq(save)
  end

  it 'should not delete cmt when not logged in', skip_before: true do
    post :destroy, xhr: true, params: { id: save_cmt.id }
    expect(user_mike.comments.count).to eq(save)
  end

  it 'should not save cmt when not logged in', skip_before: true do
    post :create, params: { content: 'this is test string', micropost_id: micropost.id }
    expect(Comment.count).to eq(save)
  end

  it 'should not delete cmt when not logged in', skip_before: true do
    post :destroy, xhr: true, params: { id: save_cmt.id }
    expect(user_mike.comments.count).to eq(save)
  end
end
