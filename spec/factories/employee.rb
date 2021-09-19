FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
