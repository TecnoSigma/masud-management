FactoryBot.define do
  factory :customer do
    company { Faker::Company.name }
    cnpj { Faker::Base.regexify(/^\d{2}.\d{3}.\d{3}\/\d{4}-\d{2}$/) }
    email { Faker::Internet.email }
    secondary_email { Faker::Internet.email }
    tertiary_email { Faker::Internet.email }
    telephone { Faker::Base.regexify(/^\d{2} \d{4}-\d{4,5}$/) }
    password { Faker::Internet.password }
    status { FactoryBot.create(:status, name: 'ativo') }
  end
end
