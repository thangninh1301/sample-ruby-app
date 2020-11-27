describe ExportCsvService do
  let(:user_mike) { create(:user_mike) }
  let!(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:micropost_csv) do
    ExportCsvService.new Micropost.last_month.by_user(user_mike),
                         Micropost::CSV_ATTRIBUTES,
                         %w[Date Post]
  end
  let(:hash) do
    hash = {}
    hash['first'] = micropost_csv
    hash['second'] = micropost_csv
    hash
  end
  let(:zip_service) { ExportZipService.new hash }
  before(:each) do
    @list_file_name = []
    Zip::File.open_buffer(zip_service.send(:zip_file)) do |zip|
      zip.each do |each|
        @list_file_name << each.name
      end
    end
  end

  it 'should eq hash ' do
    expect(@list_file_name.count).to eq(hash.count)
    expect(@list_file_name).to include('first.csv')
    expect(@list_file_name).to include('second.csv')
  end
end
