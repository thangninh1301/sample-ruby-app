require 'rails_helper'

describe ExportCsvController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:micropost_csv) do
    ExportCsvService.new Micropost.last_month.by_user(user_mike),
                         Micropost::CSV_ATTRIBUTES,
                         %w[Date Post]
  end
  let(:following_csv) do
    ExportCsvService.new user_mike.following_last_month,
                         User::CSV_ATTRIBUTES,
                         %w[Date Name]
  end
  let(:followers_csv) do
    ExportCsvService.new user_mike.followed_last_month,
                         User::CSV_ATTRIBUTES,
                         %w[Date Name]
  end
  context 'when user is logged in' do
    let(:hash) { assigns(:hash) }
    before(:each) do
      sign_in user_mike
      user_mike.follow(another_user)
      another_user.follow(user_mike)
    end

    context 'with new created (<1.month) do download zip' do
      before(:each) do
        get :index, xhr: true
      end

      it 'should include micropost in csv file' do
        expect(hash['micropost'].perform).to include('Lorem ipsum')
      end

      it 'should include following user in csv file' do
        expect(hash['following'].perform).to include(another_user.name)
      end

      it 'should include followed user in csv file' do
        expect(hash['followers'].perform).to include(another_user.name)
      end

      it 'should include zip in header' do
        expect(response.headers['Content-Type']).to eq('application/zip')
        expect(response.headers['Content-Disposition']).to include('CSV.zip')
        expect(controller.headers['Content-Transfer-Encoding']).to eq('binary')
      end
    end

    context 'with old created (>1.month) do download zip' do
      before(:each) do
        Relationship.update_all(created_at: Time.now - 2.month)
        Micropost.update_all(created_at: Time.now - 2.month)
        get :index, xhr: true
      end
      it 'should not include micropost in csv file' do
        expect(hash['micropost'].perform).to eq("Date,Post\n")
      end

      it 'should not include following in csv file' do
        expect(hash['following'].perform).to eq("Date,Name\n")
      end

      it 'should not include follower in csv file' do
        expect(hash['followers'].perform).to eq("Date,Name\n")
      end
    end
  end

  it 'should redirect to root if not logged in' do
    get :index, xhr: true
    expect(response.body).to include 'You need to sign in or sign up before continuing'
    expect(response.code).to eq('401')
  end
end
