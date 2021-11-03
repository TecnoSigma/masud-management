FactoryBot.define do
  factory :mission do
    started_at { nil }
    finished_at { nil }
    status { FactoryBot.create(:status, name: 'confirmada') }
  end

  trait :started do
    started_at { 1.days.after }
    finished_at { nil }
    status { FactoryBot.create(:status, name: 'iniciada') }
  end

  trait :finished do
    finished_at { 2.days.after }
    status { FactoryBot.create(:status, name: 'finalizada') }
  end
end
