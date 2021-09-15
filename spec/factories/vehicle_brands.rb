FactoryBot.define do
  factory :vehicle_brand do
    brand { ['VW', 'FORD', 'CHEVROLET'].sample }
  end
end
