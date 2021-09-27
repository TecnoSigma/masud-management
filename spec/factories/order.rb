FactoryBot.define do
  factory :order do
    job_day { [*1..20].sample.days.after }
    source_address { Faker::Address.street_name }
    source_number { Faker::Number.number(digits: 3) }
    source_complement { ['casa 1', 'apto 123', 'fundos'].sample }
    source_district { %w(Centro Lapa Sé).sample }
    source_city { FactoryBot.create(:city).name }
    source_state { FactoryBot.create(:state).name }
    destiny_address { Faker::Address.street_name }
    destiny_number { Faker::Number.number(digits: 3) }
    destiny_complement { ['casa 1', 'apto 123', 'fundos'].sample }
    destiny_district { %w(Centro Lapa Sé).sample }
    destiny_city { FactoryBot.create(:city).name }
    destiny_state { FactoryBot.create(:state).name }
    observation { Faker::Lorem.sentence }
    status { FactoryBot.create(:status, name: 'agendado') }
    customer { FactoryBot.create(:customer) }
  end

  trait :scheduled do
    type { 'EscortScheduling' }
    status { FactoryBot.create(:status, name: 'agendado') }
  end

  trait :confirmed do
    type { 'EscortService' }
    status { FactoryBot.create(:status, name: 'confirmado') }
  end

  trait :refused do
    type { 'EscortService' }
    reason { Faker::Lorem.sentence }
    status { FactoryBot.create(:status, name: 'recusado') }
  end
end
