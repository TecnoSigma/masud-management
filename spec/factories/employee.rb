FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admission_date { 200.days.ago }
    resignation_date { nil }
    rg { Faker::Base.regexify(/^\d{2}.\d{3}.\d{3}-\d{1}$/) }
    cpf { Faker::Base.regexify(/^\d{3}.\d{3}.\d{3}-\d{2}$/) }
    status { FactoryBot.create(:status, name: 'ativo') }
    service_token { FactoryBot.create(:service_token) }

    trait :admin do
      type { 'Administrator' }
      email { 'admin@admin.com.br' }
      password { '123456' }
      team_id { nil }
    end

    trait :agent do
      type { 'Agent' }
      email { 'agent@agent.com.br' }
      codename { name.split(' ').last }
      cvn_number {  Faker::Base.regexify(/^\d{4}\/\d{4}$/) }
      cvn_validation_date { 60.days.after }
    end

    trait :lecturer do
      type { 'Lecturer' }
      email { 'lecturer@lecturer.com.br' }
      password { '123456' }
      team_id { nil }
    end

    trait :approver do
      type { 'Approver' }
      email { 'approver@approver.com.br' }
      password { '123456' }
      team_id { nil }
    end

    trait :operator do
      type { 'Operator' }
      email { 'operator@operator.com.br' }
      password { '123456' }
      team_id { nil }
    end
  end
end
