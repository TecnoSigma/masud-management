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

    trait :agent do
      codename { name.split(' ').last }
      cvn_number {  Faker::Base.regexify(/^\d{4}\/\d{4}$/) }
      cvn_validation_date { 60.days.after }
      team { FactoryBot.create(:team) }
    end
  end
end
