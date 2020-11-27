describe ExportCsvService do
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
    ExportCsvService.new another_user.followed_last_month,
                         User::CSV_ATTRIBUTES,
                         %w[Date Name]
  end

  before(:each) do
    user_mike.follow(another_user)
  end

  it 'should include micropost content' do
    expect(micropost_csv.perform).to include('Lorem ipsum')
  end

  it 'should include following user in csv file' do
    expect(following_csv.perform).to include(another_user.name)
  end

  it 'should include followed user in csv file' do
    expect(followers_csv.perform).to include(user_mike.name)
  end

  context 'with old created (>1.month)' do
    before(:each) do
      Relationship.update_all(created_at: Time.now - 2.month)
      Micropost.update_all(created_at: Time.now - 2.month)
    end

    it 'should not include micropost in csv file' do
      expect(micropost_csv.perform).to eq("Date,Post\n")
    end

    it 'should not include following in csv file' do
      expect(following_csv.perform).to eq("Date,Name\n")
    end

    it 'should not include follower in csv file' do
      expect(followers_csv.perform).to eq("Date,Name\n")
    end
  end
end
