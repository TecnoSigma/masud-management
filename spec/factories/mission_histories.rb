FactoryBot.define do
  factory :mission_history do
    team { %w[Alpha Bravo Delta].sample }
    agents { %w[Silva Souza Mattos].sample(2).join(' | ') }
    items { %w[Rádio Viatura Colete].sample(2).join(' | ') }
  end
end
