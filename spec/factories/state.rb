FactoryBot.define do
  factory :state do
    name { ['Amazonas', 'Paraná'].sample }
    external_id { [1,2,3,4,5,6].sample }
  end
end
