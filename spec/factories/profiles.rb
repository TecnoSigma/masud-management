FactoryBot.define do
  factory :profile do
    trait :administrator do
      name { 'Adminstrador' }
      kind { 'administrator' }
    end

    trait :agent do
      name { 'Agente' }
      kind { 'agent' }
    end

    trait :approver do
      name { 'Aprovador' }
      kind { 'approver' }
    end

    trait :lecturer do
      name { 'Conferente' }
      kind { 'lecturer' }
    end

    trait :operator do
      name { 'Operador' }
      kind { 'operator' }
    end
  end
end
