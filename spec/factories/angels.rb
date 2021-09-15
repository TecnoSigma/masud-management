FactoryBot.define do
  factory :angel do
    name { Faker::Name.name }
    cpf { Faker::Base.regexify('\d{3}.\d{3}.\d{3}-\d{2}') }
    status { Status::STATUSES[:activated] } 
  end
end
