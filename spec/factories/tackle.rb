FactoryBot.define do
  factory :tackle do
    serial_number { Faker::Number.number(digits: 4) }
    register_number { Faker::Number.number(digits: 4) }
    brand { Faker::Company.name }
    fabrication_date { 200.days.ago }
    validation_date { 100.days.after }
    protection_level { %w(A B C D E ).sample }
    bond_date { 10.days.ago }
    situation { 'regular' }
    status { Status.find_by_name('ativo') || FactoryBot.create(:status, name: 'ativo') }

    trait :radio do
      type { 'Radio' }
      serial_number { Random.rand(1000) }
    end

    trait :waistcoat do
      type { 'Waistcoat' }
      protection_level { %w( A B C D E).sample }
    end
  end
end
