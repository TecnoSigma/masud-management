require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#convert_date_time' do
    it 'returns converted date in format dd/mm/yyyy - hh:mm:ss' do
      scheduling = FactoryBot.create(:order, :scheduled)

      expected_result = DateTime.parse(scheduling.job_day.to_s).strftime('%d/%m/%Y - %H:%M')

      result = helper.convert_date_time(scheduling.job_day)

      expect(result).to eq(expected_result)
    end
  end

  describe '#order_color' do
    it 'returns font blue class when the order is scheduled' do
      order = FactoryBot.create(:order, :scheduled)

      expected_result = 'scheduled-order'

      result = helper.order_color(order)

      expect(result).to eq(expected_result)
    end

    it 'returns font green class when the order is confirmed' do
      order = FactoryBot.create(:order, :confirmed)

      expected_result = 'confirmed-order'

      result = helper.order_color(order)

      expect(result).to eq(expected_result)
    end

    it 'returns font red class when the order is refused' do
      order = FactoryBot.create(:order, :refused)

      expected_result = 'refused-order'

      result = helper.order_color(order)

      expect(result).to eq(expected_result)
    end
  end
end
