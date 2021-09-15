require 'rails_helper'

RSpec.describe States do
  describe '.all_names' do
    it 'returns all state names' do
      result = ['Acre',
                'Alagoas',
                'Amapá',
                'Amazonas',
                'Bahia',
                'Ceará',
                'Distrito Federal',
                'Espírito Santo',
                'Goiás',
                'Maranhão',
                'Mato Grosso',
                'Mato Grosso do Sul',
                'Minas Gerais',
                'Paraná',
                'Paraíba',
                'Pará',
                'Pernambuco',
                'Piauí',
                'Rio Grance do Sul',
                'Rio Grande do Norte',
                'Rio de Janeiro',
                'Rondônia',
                'Roraima',
                'Santa Catarina',
                'Sergipe',
                'São Paulo',
                'Tocantins']

      expect(States.all_names).to eq(result)
    end
  end

  describe '.state_name' do
    it 'returns state name when pass federative unit' do
      expect(described_class.state_name('ES')).to eq('Espírito Santo')
    end
  end

  describe '.federative_unit' do
    it 'returns federative unit when pass state name' do
      expect(described_class.federative_unit('Paraná')).to eq('PR')
    end
  end
end

