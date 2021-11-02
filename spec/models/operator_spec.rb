# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operator, type: :model do
  it 'validates inheritance of Operator with Employee' do
    expect(described_class).to be < Employee
  end

  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Operator' do
      operator = Operator.new

      expect(operator).to respond_to(:status)
    end

    it 'no validates relationship (N:1) between Team and Operator' do
      operator = Operator.new

      expect(operator).not_to respond_to(:team)
    end

    it 'no validates relationship (1:N) between Clothing and Operator' do
      operator = Operator.new

      expect(operator).not_to respond_to(:clothes)
    end
  end
end
