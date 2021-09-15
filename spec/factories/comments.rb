FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    author { Faker::Name.name }
  end
end
