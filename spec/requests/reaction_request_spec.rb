require 'rails_helper'

describe ReactionController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:comment) { user_mike.comments.create(content: 'Lorem ipsum', micropost_id: micropost.id) }
  let!(:reaction) { micropost.reactions.create(reactor_id: user_mike.id, icon_id: 1) }

  context 'when user is logged in' do
    before(:each) do
      sign_in user_mike
    end
    it 'should update reaction if existed' do
      expect do
        post :create, xhr: true, params: { react_to_id: micropost.id, react_to_type: micropost.class.name, icon_id: 4 }
      end
        .to change { Reaction.last.icon_id }.from(1).to(4)
                                            .and change(Notification, :count).by(1)
      expect(response).to render_template('reaction/create')
    end

    it 'should create reaction' do
      expect do
        post :create, xhr: true, params: { react_to_id: comment.id, react_to_type: comment.class.name, icon_id: 4 }
      end
        .to change(Reaction, :count).by(1)
                                    .and change(Notification, :count).by(1)
      expect(response).to render_template('reaction/create')
    end

    it 'should delete reaction' do
      expect do
        post :destroy, xhr: true, params: { id: reaction.id, micropost_id: micropost }
      end
        .to change(Reaction, :count).by eq(-1)
      expect(response).to render_template('reaction/destroy')
    end
  end

  context 'when user is not logged in' do
    it 'should not delete reaction' do
      expect do
        post :destroy, xhr: true, params: { id: reaction.id, micropost_id: micropost }
      end
        .to change(Reaction, :count).by eq(0)
      expect(response.body).to include 'You need to sign in or sign up before continuing'
      expect(response.code).to eq('401')
    end

    it 'should not create reaction' do
      expect do
        post :create, xhr: true, params: { react_to_id: comment.id, react_to_type: comment.class.name, icon_id: 4 }
      end
        .to change(Reaction, :count).by eq(0)
      expect(response.body).to include 'You need to sign in or sign up before continuing'
      expect(response.code).to eq('401')
    end
  end

  context 'when logged in with another user' do
    before(:each) do
      sign_in another_user
    end

    it 'should not delete reaction' do
      expect do
        post :destroy, xhr: true, params: { id: reaction.id, micropost_id: micropost }
      end
        .to change(Reaction, :count).by eq(0)
      expect(response).to redirect_to root_url
      expect(flash[:alert]).to be_present
    end
  end
end
