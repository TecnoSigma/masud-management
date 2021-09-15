FactoryBot.define do
  factory :camera do
    kind { 'IC3 - Mibo' }
    ip { Faker::Internet.ip_v4_address }
    password { Faker::Internet.password }
  end
end
