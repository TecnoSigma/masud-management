FactoryBot.define do
  factory :vehicle_model do
    kind { ['KA', 'PALIO', 'GOL'].sample }
  end
end
