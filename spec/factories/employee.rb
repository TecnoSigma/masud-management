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

    trait :admin do
      email { 'agent@agent.com.br' }
      password { '123456' }
      team_id { nil }
      profiles { [FactoryBot.create(:profile, name: 'Administrador', kind: 'administrator'),
                  FactoryBot.create(:profile, name: 'Aprovador', kind: 'approver')] }
    end

    trait :agent do
      email { 'agent@agent.com.br' }
      password { '123456' }
      codename { name.split(' ').last }
      cvn_number {  Faker::Base.regexify(/^\d{4}\/\d{4}$/) }
      cvn_validation_date { 60.days.after }
      profiles { [FactoryBot.create(:profile, name: 'Agente', kind: 'agent')] }
    end

    trait :lecturer do
      email { 'lecturer@lecturer.com.br' }
      password { '123456' }
      team_id { nil }
      profiles { [FactoryBot.create(:profile, name: 'Conferente', kind: 'lecturer')] }
    end

    trait :operator do
      email { 'operator@operator.com.br' }
      password { '123456' }
      team_id { nil }
      profiles { [FactoryBot.create(:profile, name: 'Operador', kind: 'operator')] }
    end
  end
end
