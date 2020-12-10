class ExportCsvController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @hash = {}
    @hash['micropost'] = ExportCsvService.new Micropost.last_month.by_user(current_user),
                                              Micropost::CSV_ATTRIBUTES,
                                              %w[Date Post]
    @hash['following'] = ExportCsvService.new current_user.following_last_month, User::CSV_ATTRIBUTES, %w[Date Name]
    @hash['followers'] = ExportCsvService.new current_user.followed_last_month, User::CSV_ATTRIBUTES, %w[Date Name]
    respond_to do |format|
      export_zip = ExportZipService.new @hash
      format.zip { send_data export_zip.zip_file.read, filename: 'CSV.zip' }
    end
  end
end
