FactoryBot.define do
  factory :arsenal do
    trait :gun do
      type { 'Gun' }
      number { Faker::Base.regexify(/^\w{1,10}$/) }
      kind { %w(Espingarda Revólver).sample }
      caliber { kind == 'Espingarda' ? '12' : '38' }
      sinarm { Faker::Base.regexify(/^\d{15}$/) }
      situation { %w[regular irregular].sample }
      status { Status.find_by_name('ativo') || FactoryBot.create(:status, name: 'ativo') }
      registration_validity { 90.days.after }
    end
  end
end
