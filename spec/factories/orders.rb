FactoryBot.define do
  factory :order do
    price { Faker::Number.decimal(2) }
    status { Status::ORDER_STATUSES[:pendent] }
  end
end
