FactoryBot.define do
  factory :customer do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
