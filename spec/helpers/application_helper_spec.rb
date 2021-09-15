require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#convert_float_to_currency' do
    it 'returns converted value in currency (R$)' do
      value = 1234.66

      expect(helper.convert_float_to_currency(value)).to eq('R$ 1.234,66')
    end
  end

  describe '#month_list' do
    it 'returns numeric monthies list' do
      expected_result = %w(01 02 03 04 05 06 07 08 09 10 11 12) 

      expect(helper.month_list).to eq(expected_result)
    end
  end

  describe '#year_list' do
    it 'returns year list from twelve year after' do
      expected_result = [*(Time.now.year)..(Time.now.year + 20)]

      expect(helper.year_list).to eq(expected_result)
    end
  end

  describe '#convert_date' do
    it 'returns converted date in format dd/mm/yyyy - hh:mm:ss' do
      date = DateTime.now

      expected_result = date.strftime('%d/%m/%Y - %H:%M:%S')

      expect(helper.convert_date(date)).to eq(expected_result)
    end
  end

  describe 'formatted_date' do
    it 'returns formatted date' do
      date = DateTime.now

      expected_result = date.strftime('%d/%m/%Y')

      expect(helper.formatted_date(date)).to eq(expected_result)
    end
  end

  describe '#extensive_number' do
    it 'returns number in extensive format' do
      number = 1233.39

      expected_result = 'um mil, duzentos e trinta e três de reais e trinta e nove centavos'

      expect(helper.extensive_number(number)).to eq(expected_result)
    end
  end

  describe '#leading_zeros' do
    it 'returns number with leading zeros' do
      number = 3
      leading_zeros = 6

      expected_result = '000003'

      expect(helper.leading_zeros(number: number, leading_zeros: leading_zeros)).to eq(expected_result)
    end
  end
end
