FactoryBot.define do
  factory :ticket do
    department { ['Financeiro', 'Suporte'].sample }
    responsible { Faker::Name.name }
    subject { Faker::Lorem.sentence }
    delayed { false }
    finished { false }
    recurrence { false }
    status { Status::TICKET_STATUSES[:opened] }
  end
end
