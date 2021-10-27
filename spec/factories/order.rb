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
    status { Status.find_by_name('agendado') || FactoryBot.create(:status, name: 'agendado') }
    customer { FactoryBot.create(:customer) }
  end

  trait :scheduled do
    type { 'EscortScheduling' }
    status { Status.find_by_name('agendado') || FactoryBot.create(:status, name: 'agendado') }
  end

  trait :cancelled_by_customer do
    type { 'EscortScheduling' }
    status { Status.find_by_name('cancelado pelo cliente') || FactoryBot.create(:status, name: 'cancelado pelo cliente') }
  end

  trait :confirmed do
    type { 'EscortService' }
    status { Status.find_by_name('confirmado') || FactoryBot.create(:status, name: 'confirmado') }
  end

  trait :refused do
    type { 'EscortService' }
    reason { Faker::Lorem.sentence }
    status { Status.find_by_name('recusado') || FactoryBot.create(:status, name: 'recusado') }
  end
end
