FactoryBot.define do
  factory :tackle do
    trait :radio do
      serial_number { Random.rand(100) }
    end
  end
end
