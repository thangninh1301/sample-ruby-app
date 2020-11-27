class ExportZipService
  require 'csv'

  def initialize(hash)
    @hash = hash
  end

  def zip_file
    compressed_filestream = Zip::OutputStream.write_buffer(::StringIO.new('')) do |zip|
      @hash.each do |key, value|
        zip.put_next_entry "#{key}.csv"
        zip.print value.perform
      end
    end
    compressed_filestream.rewind
    compressed_filestream
  end

  private

  attr_reader :hash
end
