require 'rails_helper'

RSpec.describe  Dashboards::Sellers::Informations::BankingHelper, type: :helper do
  include  Dashboards::Sellers::Informations::BankingHelper

  describe '#bank_list' do
    it 'returns bank list containing COMPE register and bank name' do
      compe_register = '12345-Z'
      name = 'Banco ABC S.A.'
      bank = FactoryBot.create(:bank, compe_register: compe_register, name: name)

      expected_result = [["#{compe_register} - #{name}", "#{compe_register}"]]

      expect(helper.bank_list).to eq(expected_result)
    end
  end
end
