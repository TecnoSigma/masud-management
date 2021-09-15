FactoryBot.define do
  factory :rating do
    rate { Rating::DEFAULT_RATE }
    comment { "MyString" }
  end
end
