FactoryBot.define do
  factory :service_token do
    token { SecureRandom.uuid }
  end
end
