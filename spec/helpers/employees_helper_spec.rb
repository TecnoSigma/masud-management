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
end
