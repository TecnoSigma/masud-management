# frozen_string_literal:true

require 'rails_helper'

RSpec.describe Regex do
  describe '.cnpj' do
    it 'checks valid CNPJ' do
      cnpj = '12.345.677/0001-33'

      expect(described_class.cnpj).to match(cnpj)
    end

    it 'checks invalid CNPJ' do
      cnpj = '12.345.677/00000-11'

      expect(described_class.cnpj).not_to match(cnpj)
    end
  end

  describe '.telephone' do
    it 'checks valid telephone' do
      telephone1 = '(11) 5234-8888'
      telephone2 = '(11) 91234-8888'

      expect(described_class.telephone).to match(telephone1)
      expect(described_class.telephone).to match(telephone2)
    end

    it 'checks invalid telephone' do
      telephone1 = '(11 1234 8888'
      telephone2 = '(11 91234 8888'

      expect(described_class.telephone).not_to match(telephone1)
      expect(described_class.telephone).not_to match(telephone2)
    end
  end
end
