FactoryBot.define do
  factory :munition_stock do
    caliber { %w[38 12].sample }
    quantity { Faker::Number.number(digits: 3) }
    last_update { 3.days.ago }
  end
end
