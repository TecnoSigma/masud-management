FactoryBot.define do
  factory :city do
    name { ['Bauru', 'Sorocaba'].sample }
    state { FactoryBot.create(:state) }
  end
end
