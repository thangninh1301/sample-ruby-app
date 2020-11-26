require 'rails_helper'

describe ExportCsvController, type: :controller do
  let(:user_mike) { create(:user_mike) }
  let(:another_user) { create(:another_user) }
  let!(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:micropost_csv) { ExportCsvService.new Micropost.last_month.by_user(user_mike), Micropost::CSV_ATTRIBUTES, %w[Date Post], user_mike }
  let(:following_csv) { ExportCsvService.new user_mike.following_last_month, User::CSV_ATTRIBUTES, %w[Date Name], user_mike }
  let(:followers_csv) { ExportCsvService.new user_mike.followed_last_month, User::CSV_ATTRIBUTES, %w[Date Name], user_mike }
  context 'when user is logged in' do
    let(:hash) { assigns(:hash) }
    before(:each) do
      session[:user_id] = user_mike.id
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

  it 'should include micropost content' do
    expect(micropost_csv.perform).to include('Lorem ipsum')
  end

  context 'with zip_file in class ExportCsvController' do
    let(:hash) do
      hash = {}
      hash['micropost'] = micropost_csv
      hash['following'] = following_csv
      hash['followers'] = followers_csv
      hash
    end
    before(:each) do
      @list_file_name = []
      obj = ExportZipService.new hash
      Zip::File.open_buffer(obj.send(:zip_file)) do |zip|
        zip.each do |each|
          @list_file_name << each.name
        end
      end
    end
    it 'should include 3 file' do
      expect(@list_file_name.count).to eq(3)
      expect(@list_file_name).to include('following.csv')
      expect(@list_file_name).to include('followers.csv')
      expect(@list_file_name).to include('micropost.csv')
    end
  end

  it 'should redirect to root if not logged in' do
    get :index, xhr: true
    expect(response).to redirect_to login_url
  end
end
