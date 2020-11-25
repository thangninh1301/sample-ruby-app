class ExportCsvService
  require 'csv'

  def initialize(objects, attributes, header, current_user)
    @attributes = attributes
    @objects = objects
    @header = header.map(&:to_s)
    @current_user = current_user
  end

  def perform
    CSV.generate do |csv|
      csv << header
      objects.each do |object|
        if (Time.now - created_time(object)) < 1.month
          (csv << attributes.map { |attr| object.public_send(attr) })
        end
      end
    end
  end

  private

  attr_reader :attributes, :objects, :header

  def created_time(object)
    is_user = object.instance_of? User
    temp = is_user ? Relationship.find_relationship(@current_user.id, object.id).first : object
    temp.created_at
  end
end
