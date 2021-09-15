FactoryBot.define do
  factory :router do
    operator { ['Vivo', 'Claro', 'TIM', 'Oi'].sample }
    kind { 'Mod-12345' }
    user { Faker::Internet.username }
    password { Faker::Internet.password }
    imei { SecureRandom.uuid.upcase.remove('-') }
  end
end
