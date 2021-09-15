FactoryBot.define do
  factory :seller do
    name { Faker::Name.name }
    password { Faker::Internet.password }
    core_register { "#{Faker::Number.number(7)}/#{DateTime.now.year - 3}" }
    expedition_date { DateTime.yesterday }
    expiration_date { DateTime.tomorrow }
    document { Faker::Base.regexify('\d{3}.\d{3}.\d{3}-\d{2}') }
    code { "seller-#{document.gsub('.','').gsub('-','')}" if document.present? }
    address { Faker::Address.street_name }
    number { Faker::Number.number(2) }
    complement { ['frente', 'fundos'].sample }
    district { 'Centro' }
    city { Faker::Address.city }
    state { Faker::Address.state }
    postal_code { Faker::Base.regexify('\d{5}-\d{3}') }
    cellphone {"(#{Faker::Base.regexify('([1-9]{2})')}) " \
                "#{Faker::Base.regexify('9 [0-9]{4}')} "   \
                "#{Faker::Base.regexify('[0-9]{4}')}" }
    email { Faker::Internet.email}
    linkedin { 'https://www.linkedin.com/in/thiago-munizo-727036175' }
    status { Status::STATUSES[:activated] }
  end
end
