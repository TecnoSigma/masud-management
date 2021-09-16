FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :administrator do
      kind { 'administrator' }
    end
  end
end
