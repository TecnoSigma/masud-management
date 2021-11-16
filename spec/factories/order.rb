FactoryBot.define do
  factory :order do
    job_day { 10.days.after.strftime('%d/%m/%Y') }
    job_horary { "#{'%02d' % rand(0..23)}:#{'%02d' % rand(0..59)}" }
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
    status { Status.find_by_name('aguardando confirmação') || FactoryBot.create(:status, name: 'aguardando confirmação') }
    customer { FactoryBot.create(:customer) }
  end

  trait :scheduled do
    type { 'EscortScheduling' }
    status { Status.find_by_name('aguardando confirmação') || FactoryBot.create(:status, name: 'aguardando confirmação') }
  end

  trait :blocked do
    type { 'EscortScheduling' }
    reason { Faker::Lorem.sentence }
    status { Status.find_by_name('bloqueada') || FactoryBot.create(:status, name: 'bloqueada') }
  end

  trait :cancelled_by_customer do
    type { 'EscortScheduling' }
    status { Status.find_by_name('cancelada pelo cliente') || FactoryBot.create(:status, name: 'cancelada pelo cliente') }
  end

  trait :confirmed do
    type { 'EscortService' }
    status { Status.find_by_name('confirmada') || FactoryBot.create(:status, name: 'confirmada') }
  end

  trait :refused do
    type { 'EscortService' }
    reason { Faker::Lorem.sentence }
    status { Status.find_by_name('recusada') || FactoryBot.create(:status, name: 'recusada') }
  end
end
