FactoryBot.define do
  factory :customer do
    company { Faker::Company.name }
    cnpj { Faker::Base.regexify(/^\d{2}.\d{3}.\d{3}\/\d{4}-\d{2}$/) }
    email { Faker::Internet.email }
    secondary_email { Faker::Internet.email }
    tertiary_email { Faker::Internet.email }
    telephone { "(21) 9#{Faker::Number.number(digits: 4)}-#{Faker::Number.number(digits: 4)}" }
    status { Status.find_by_name('ativo') || FactoryBot.create(:status, name: 'ativo') }
    service_token { FactoryBot.create(:service_token) }
  end
end
