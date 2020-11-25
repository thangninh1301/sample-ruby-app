class ExportCsvController < ApplicationController
  def index
    micropost_csv = ExportCsvService.new current_user.microposts, Micropost::CSV_ATTRIBUTES, %w[Date Post]
    following_csv = ExportCsvService.new current_user.following, User::CSV_ATTRIBUTES, %w[Date Name]
    followers_csv = ExportCsvService.new current_user.followers, User::CSV_ATTRIBUTES, %w[Date Name]
    respond_to do |format|
      format.csv do
        send_data following_csv.perform,
                  filename: 'users.csv'
      end
    end
  end
end
