FactoryBot.define do
  factory :subscription do
    code { SecureRandom.uuid }
    status { Status::STATUSES[:activated] }
    vehicles_amount { Faker::Number.number(2) }
  end
end
