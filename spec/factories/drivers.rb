FactoryBot.define do
  factory :driver do
    name { Faker::Name.name }
    code { "driver-#{Faker::Number.number(14)}" }
    license { Faker::Base.regexify(/\d{2}.\d{3}.\d{3}.\d{3}/) }
    paid_activity { true }
    expedition_date { DateTime.yesterday }
    expiration_date { DateTime.tomorrow }
    status { Status::STATUSES[:activated] }
  end
end
