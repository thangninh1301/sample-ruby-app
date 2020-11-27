class ExportCsvService
  require 'csv'

  def initialize(objects, attributes, header)
    @attributes = attributes
    @objects = objects
    @header = header.map(&:to_s)
  end

  def perform
    CSV.generate do |csv|
      csv << header
      objects.each do |object|
        (csv << attributes.map { |attr| object.public_send(attr) })
      end
    end
  end

  private

  attr_reader :attributes, :objects, :header
end
