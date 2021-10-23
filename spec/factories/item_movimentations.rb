FactoryBot.define do
  factory :item_movimentation do
    quantity { Faker::Number.numger(digits: 2) }

    trait :gun do
      arsenal { FactoryBot.create(:arsenal, :gun) }
    end

    trait :munition do
      arsenal { FactoryBot.create(:arsenal, :munition) }
    end

    trait :radio do
      tackle { FactoryBot.create(:tackle, :radio) }
    end

    trait :waistcoat do
      tackle { FactoryBot.create(:tackle, :waistcoat) }
    end

    trait :vehicle do
      vehicle { FactoryBot.create(:vehicle) }
    end
  end
end
