FactoryBot.define do
  factory :mission_history do
    team { %w[Alpha Bravo Delta].sample }
    agents { %w[Silva Souza Mattos] }
    items { %w[Rádio Viatura Colete] }
  end
end
