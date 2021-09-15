FactoryBot.define do
  factory :delivery_city do
    federative_unit { "MyString" }
    locality { "MyString" }
    initial_postal_code { "MyString" }
    final_postal_code { "MyString" }
    express_time { 1 }
    road_time { 1 }
    price { "MyString" }
    destiny_freight { "MyString" }
    distributor { "MyString" }
    redispatch { "MyString" }
    risk_group { 1 }
  end
end
