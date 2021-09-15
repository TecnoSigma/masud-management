FactoryBot.define do
  factory :plan do
    name { PLAN_CONFIG[:plans][:data].pluck(:name).sample }
    price { Faker::Number.decimal.to_f }
    status { Status::STATUSES[:activated] }
    code { "#{Faker::Lorem.word}-angels" }
  end
end
