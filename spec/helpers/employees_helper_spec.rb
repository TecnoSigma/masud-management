# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesHelper, type: :helper do
  include ApplicationHelper

  describe '#profile' do
    it 'returns profile \'Administrador\'' do
      result = helper.profile('administrator')

      expected_result = 'Administrador'

      expect(result).to eq(expected_result)
    end

    it 'returns profile \'Agente\'' do
      result = helper.profile('agent')

      expected_result = 'Agente'

      expect(result).to eq(expected_result)
    end

    it 'returns profile \'Aprovador\'' do
      result = helper.profile('approver')

      expected_result = 'Aprovador'

      expect(result).to eq(expected_result)
    end

    it 'returns profile \'Conferente\'' do
      result = helper.profile('lecturer')

      expected_result = 'Conferente'

      expect(result).to eq(expected_result)
    end

    it 'returns profile \'Operador\'' do
      result = helper.profile('operator')

      expected_result = 'Operador'

      expect(result).to eq(expected_result)
    end
  end

  describe '#highlight_expired_cvn' do
    context 'when employee is an Agent' do
      it 'returns CSS class name when have expired CVN' do
        employee = FactoryBot.create(:employee, :agent, cvn_validation_date: Date.yesterday)

        agent = Agent.find_by_name(employee.name)

        result = helper.highlight_expired_cvn(agent)

        expected_result = 'expired-cvn'

        expect(result).to eq(expected_result)
      end

      it 'no returns CSS class name when haven\'t expired CVN' do
        employee = FactoryBot.create(:employee, :agent, cvn_validation_date: Date.tomorrow)

        agent = Agent.find_by_name(employee.name)

        result = helper.highlight_expired_cvn(agent)

        expect(result).to eq('')
      end
    end

    context 'when employee isn\'t an Agent' do
      it 'no returns CSS class name' do
        employee = FactoryBot.create(:employee, :operator)

        operator = Operator.find_by_name(employee.name)

        result = helper.highlight_expired_cvn(operator)

        expect(result).to eq('')
      end
    end
  end
end
