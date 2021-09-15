FactoryBot.define do
  factory :subscriber do
    code { "subscriber-#{Faker::Number.number(14)}" }
    name { Faker::Name.name }
    responsible_name { Faker::Name.name }
    responsible_cpf { Faker::Base.regexify('\d{3}.\d{3}.\d{3}-\d{2}') }
    document { Faker::Base.regexify('\d{2}.\d{3}.\d{3}/\d{4}-\d{2}') }
    kind { ['PF', 'PJ'].sample }
    address { Faker::Address.street_name }
    number { Random.rand(1..100) }
    complement { ['casa 1', 'sobreloja', 'fundos'].sample }
    district { Faker::Address.city }
    city { Faker::Address.city }
    state { States.all_names.sample }
    postal_code { Faker::Base.regexify('\d{5}-\d{3}') }
    ip { Faker::Internet.ip_v4_address }
    email { Faker::Internet.email }
    telephone { "(#{Faker::Base.regexify('([1-9]{2})')}) " \
                 "#{Faker::Base.regexify('[0-9]{4}')} "   \
                 "#{Faker::Base.regexify('[0-9]{4}')}" }
    cellphone {"(#{Faker::Base.regexify('([1-9]{2})')}) " \
                "#{Faker::Base.regexify('9 [0-9]{4}')} "   \
                "#{Faker::Base.regexify('[0-9]{4}')}" }
    user do
      Faker::Internet
        .user_name(6..12)
        .delete('.')
        .delete('-')
        .delete('_')
    end
    password { Faker::Internet.password(10, 20) }
    status { Status::STATUSES[:pendent] }
    deleted_at { nil }
    plan
  end
end
