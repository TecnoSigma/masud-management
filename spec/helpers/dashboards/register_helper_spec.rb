require 'rails_helper'

RSpec.describe Dashboards::RegisterHelper, type: :helper do
  describe '#translated_profile' do
    it 'returns \'Pessoa Jurídica\' when pass \'PJ\'' do
      kind = 'PJ'

      result = helper.translated_profile(kind)

      expect(result).to eq('Pessoa Jurídica')
    end

    it 'returns \'Pessoa Física\' when pass \'PF\'' do
      kind = 'PF'

      result = helper.translated_profile(kind)

      expect(result).to eq('Pessoa Física')
    end
  end
end
