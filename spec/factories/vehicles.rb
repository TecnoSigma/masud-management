FactoryBot.define do
  factory :vehicle do
    brand { 'Ford' }
    kind { 'Escort' }
    license_plate { Faker::Base.regexify('[A-Z]{3}-\d{4}') }
    status { Status::STATUSES[:activated] }
    subscriber
  end

  trait :deactivated do
    status { Status::STATUSES[:deactivated] }
  end
end
