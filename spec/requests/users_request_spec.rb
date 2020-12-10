require 'rails_helper'

describe UsersController, type: :controller do
  let!(:admin) { create(:user_mike) }
  let!(:another_user) { create(:another_user) }
  let!(:params) do
    { name: Faker::Name.unique.name,
      password: '',
      email: Faker::Internet.email }
  end

  before do
    User.create(name: 'test',
                password: 'pasword',
                email: 'test@gmail.com')
  end

  context 'when admin is logged in' do
    before(:each) do
      sign_in admin
    end

    it 'should update another_user info' do
      expect do
        post :update, params: { user: params, id: User.last.id }
      end
        .to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(User.last.name).to eq(params[:name])
      expect(flash[:success]).to include('Profile updated')
    end
  end

  context 'when another_user is logged in' do
    before(:each) do
      sign_in another_user
    end

    it 'should update another_user info' do
      expect do
        post :update, params: { user: params, id: User.last.id }
      end
        .to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(User.last.name).to eq('test')
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end
  end
end
