# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operator, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Operator' do
      operator = Operator.new

      expect(operator).to respond_to(:status)
    end
  end
end
