FactoryBot.define do
  factory :vehicle do
    name { Faker::Vehicle.model }
    license_plate { Faker::Base.regexify(/^\w{3} \w{4}$$/) }
    color { Faker::Color.color_name }
    status { FactoryBot.create(:status, name: 'ativo') }
  end
end
