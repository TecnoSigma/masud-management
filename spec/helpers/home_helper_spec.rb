require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  include HomeHelper

  describe '#add_check' do
    it 'returns image name (yes.svg) when pass \'true\'' do

      expect(helper.add_check('true')).to eq('yes.svg')
    end

    it 'returns image name (yes.svg) when pass \'false\'' do

      expect(helper.add_check('false')).to eq('no.svg')
    end 
  end

  describe '#price' do
    it 'returns plan price' do
      unit = '101'
      cents = '50'

      expected_result = 101.50

      expect(helper.price(unit, cents)). to eq(expected_result)
    end
  end
end
