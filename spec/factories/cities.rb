FactoryBot.define do
  factory :city do
    name { ['Bauru', 'Sorocaba'].sample }
  end
end
