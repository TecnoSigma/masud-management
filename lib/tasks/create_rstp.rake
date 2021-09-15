namespace :rstp do
  desc "Create camera access URL with RSTP protocol"

  task :create => :environment do
    camera = Camera.first

    puts "rtsp://#{camera.user}:#{camera.password}@#{camera.ip}/live/mpeg4"
  end
end
