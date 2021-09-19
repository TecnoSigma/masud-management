FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :administrator do
      kind { 'administrator' }
    end

    trait :agent do
      kind { 'agent' }
    end

    trait :approver do
      kind { 'approver' }
    end

    trait :lecturer do
      kind { 'lecturer' }
    end

    trait :operator do
      kind { 'oeprator' }
    end
  end
end
