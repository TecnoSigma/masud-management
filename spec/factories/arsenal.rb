FactoryBot.define do
  factory :arsenal do
    trait :gun do
      number { Faker::Base.regexify(/^\w{1,10}$/) }
      kind { %w(Espingarda Revólver).sample }
      caliber { kind == 'Espingarda' ? '12' : '38' }
      sinarm { Faker::Base.regexify(/^\d{15}$/) }
      situation { FactoryBot.create(:status, name: 'regular') }
      status { FactoryBot.create(:status, name: 'ativo') }
      registration_validity { 90.days.after }
    end

    trait :munition do
      kind { %w(12 38).sample }
      quantity { Faker::Number.number(digits: 3) }
    end
  end
end
