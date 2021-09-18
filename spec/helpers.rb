# frozen_string_literal: true

module Helpers
  def add_vehicle_photos(vehicle)
    file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                 Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                 Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]
    vehicle.photos.attach(file_list)
  end
end
