require 'rails_helper'

RSpec.describe CheckoutHelper, type: :helper do
  include CheckoutHelper

  describe '#information_rule' do
    it 'returns information rule with enabled identification step tag in HTML format' do
      step = 'identificação'

      expected_result = "<li class='activated-step'><span>Identificação</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Veículos</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Resumo</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Pagamento</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Finalização</span></li>"

      expect(helper.information_rule(step)).to eq(expected_result)
    end

    it 'returns information rule with enabled vehicles step tag in HTML format' do
      step = 'veículos'

      expected_result = "<li class='deactivated-step'><span>Identificação</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='activated-step'><span>Veículos</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Resumo</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Pagamento</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Finalização</span></li>"

      expect(helper.information_rule(step)).to eq(expected_result)
    end

    it 'returns information rule with enabled resume step tag in HTML format' do
      step = 'resumo'

      expected_result = "<li class='deactivated-step'><span>Identificação</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Veículos</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='activated-step'><span>Resumo</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Pagamento</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Finalização</span></li>"

      expect(helper.information_rule(step)).to eq(expected_result)
    end 

    it 'returns information rule with enabled payment step tag in HTML format' do
      step = 'pagamento'

      expected_result = "<li class='deactivated-step'><span>Identificação</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Veículos</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Resumo</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='activated-step'><span>Pagamento</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Finalização</span></li>"

      expect(helper.information_rule(step)).to eq(expected_result)
    end 

    it 'returns information rule with enabled finalization step tag in HTML format' do
      step = 'finalização'

      expected_result = "<li class='deactivated-step'><span>Identificação</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Veículos</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Resumo</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='deactivated-step'><span>Pagamento</span></li><li><i class='material-icons arrow'>label_important</i></li><li class='activated-step'><span>Finalização</span></li>"

      expect(helper.information_rule(step)).to eq(expected_result)
    end
  end

  describe '#total_price' do
    it 'returns plan total price' do
      vehicles_amount = 3
      price = 2.00
      freight = 10.0

      expected_result = 'R$ 16,00'

      expect(helper.total_price(vehicles_amount, price, freight)).to eq(expected_result)
    end
  end

  describe '#subtotal' do
    it 'returns subtotal containing sum between vehicles amount and price' do
      vehicles_amount = 3
      price = 2.00

      expected_result = 'R$ 6,00'

      expect(helper.subtotal(vehicles_amount, price)).to eq(expected_result)
    end
  end

  describe '#payment_method_list' do
    it 'returns payment method list' do
      expected_result = ['Cartão de Crédito'] 

      expect(helper.payment_method_list).to eq(expected_result)
    end
  end

  describe '#required?' do
    it "returns 'true' when vehicle list is empty" do
      vehicle_list = []

      expect(helper.required?(vehicle_list)).to eq(true)
    end

    it "returns 'false' when vehicle list isn't empty" do
      vehicle_list = [ { brand: 'Volks', kind: 'Fusca', license_plate: 'AAA-0000' } ]

      expect(helper.required?(vehicle_list)).to eq(false)
    end
  end
end
