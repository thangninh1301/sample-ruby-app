class PhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  process resize_to_fit: [800, 800]

  storage :file

  unless Rails.env.test? || Rails.env.cucumber?
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  version :fit_message_box do
    process resize_to_fill: [200, 200]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def content_type_whitelist
    %r{image/}
  end

  def filename
    @name ||= "#{timestamp}-#{super}" if original_filename.present? && super.present?
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end
end
