require 'rails_helper'

RSpec.describe Hiring do
  it 'mount hash containing hiring steps list' do
    expected_result = { identification: 'identificação',
                        vehicles: 'veículos',
                        resume: 'resumo',
                        payment: 'pagamento', 
                        finalization: 'finalização' }

    expect(Hiring::STEPS).to eq(expected_result)
  end
end
