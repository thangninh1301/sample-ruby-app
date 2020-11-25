require 'rails_helper'

describe ExportCsvController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  context 'when user is logged in' do
    before(:each) do
      session[:user_id] = user_mike.id
      user_mike.follow(another_user)
      another_user.follow(user_mike)
    end

    context 'with new created (<1.month)' do
      before(:each) do
        get :index, xhr: true
      end

      it 'should include micropost in csv file' do
        expect(assigns(:micropost_csv).perform).to include('Lorem ipsum')
      end

      it 'should include following user in csv file' do
        expect(assigns(:following_csv).perform).to include(another_user.name)
      end

      it 'should include followed user in csv file' do
        expect(assigns(:followers_csv).perform).to include(another_user.name)
      end

      it 'should include zip in header' do
        expect(response.headers['Content-Type']).to eq('application/zip')
        expect(response.headers['Content-Disposition']).to include('CSV.zip')
      end
    end

    context 'with old created (>1.month)' do
      before(:each) do
        Relationship.update_all(created_at: Time.now - 2.month)
        Micropost.update_all(created_at: Time.now - 2.month)
        get :index, xhr: true
      end
      it 'should not include micropost in csv file' do
        expect(assigns(:micropost_csv).perform).to eq("Date,Post\n")
      end

      it 'should not include following in csv file' do
        expect(assigns(:following_csv).perform).to eq("Date,Name\n")
      end

      it 'should not include follower in csv file' do
        expect(assigns(:followers_csv).perform).to eq("Date,Name\n")
      end
    end
  end
end
