# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EscortsHelper, type: :helper do
  include ApplicationHelper

  describe '#order_link' do
    context 'returns an order link' do
      it 'when is an escort scheduling' do
        customer = FactoryBot.create(:customer)
        order = FactoryBot.create(:order, :scheduled, customer: customer)

        result = helper.order_link(order.order_number)

        expected_result = "<a href=\"/gestao/admin/dashboard/escolta/#{order.order_number}\">" \
                          "#{order.order_number}" \
                          '</a>'

        expect(result).to eq(expected_result)
      end

      it 'when is an escort service' do
        customer = FactoryBot.create(:customer)
        order = FactoryBot.create(:order, :confirmed, customer: customer)

        result = helper.order_link(order.order_number)

        expected_result = "<a href=\"/gestao/admin/dashboard/escolta/#{order.order_number}\">" \
                          "#{order.order_number}" \
                          '</a>'

        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#show_reasons?' do
    it 'returns \'true\' when status is blocked' do
      status = 'bloqueado'

      result = helper.show_reasons?(status)

      expect(result).to eq(true)
    end

    it 'returns \'true\' when status is cancelled' do
      status = 'cancelada'

      result = helper.show_reasons?(status)

      expect(result).to eq(true)
    end

    it 'returns \'false\' when status is invalid' do
      status = 'any_status'

      result = helper.show_reasons?(status)

      expect(result).to eq(false)
    end
  end
end
