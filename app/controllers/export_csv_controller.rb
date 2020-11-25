class ExportCsvController < ApplicationController
  before_action :logged_in_user, only: %i[index]
  def index
    @micropost_csv = ExportCsvService.new current_user.microposts, Micropost::CSV_ATTRIBUTES, %w[Date Post], current_user
    @following_csv = ExportCsvService.new current_user.following, User::CSV_ATTRIBUTES, %w[Date Name], current_user
    @followers_csv = ExportCsvService.new current_user.followers, User::CSV_ATTRIBUTES, %w[Date Name], current_user
    puts Micropost.all.count
    respond_to do |format|
      format.zip { send_data zip_file.read, filename: 'CSV.zip' }
    end
  end

  private

  def zip_file
    compressed_filestream = Zip::OutputStream.write_buffer(::StringIO.new('')) do |zip|
      zip.put_next_entry 'following.csv'
      zip.print @following_csv.perform
      zip.put_next_entry 'followers.csv'
      zip.print @followers_csv.perform
      zip.put_next_entry 'micropost.csv'
      zip.print @micropost_csv.perform
    end
    compressed_filestream.rewind
    compressed_filestream
  end
end
