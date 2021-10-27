FactoryBot.define do
  factory :arsenal do
    trait :gun do
      type { 'Gun' }
      number { Faker::Base.regexify(/^\w{1,10}$/) }
      kind { %w(Espingarda Revólver).sample }
      caliber { kind == 'Espingarda' ? '12' : '38' }
      sinarm { Faker::Base.regexify(/^\d{15}$/) }
      situation { Status.find_by_name('regular') || FactoryBot.create(:status, name: 'regular') }
      status { Status.find_by_name('ativo') || FactoryBot.create(:status, name: 'ativo') }
      registration_validity { 90.days.after }
    end

    trait :munition do
      type { 'Munition' }
      kind { %w(12 38).sample }
      quantity { Faker::Number.number(digits: 3) }
    end
  end
end
