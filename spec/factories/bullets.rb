FactoryBot.define do
  factory :bullet do
    quantity { 1 }
    caliber { %w[12 38].sample }
  end
end
