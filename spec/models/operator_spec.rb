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

    it 'no validates relationship (1:N) between Arsenal and Operator' do
      operator = Operator.new

      expect(operator).not_to respond_to(:arsenals)
    end

    it 'no validates relationship (1:N) between Clothing and Operator' do
      operator = Operator.new

      expect(operator).not_to respond_to(:clothes)
    end

    it 'no validates relationship (1:N) between Operator and Tackle' do
      operator = Operator.new

      expect(operator).not_to respond_to(:tackles)
    end
  end

  describe 'validates presences' do
    it 'of codename' do
      operator = Operator.new(FactoryBot.attributes_for(:employee, :operator, codename: nil))

      expect(operator).to be_invalid
    end

    it 'of cvn_number' do
      operator = Operator.new(FactoryBot.attributes_for(:employee, :operator, cvn_number: nil))

      expect(operator).to be_invalid
    end

    it 'of cvn_validation_date' do
      operator = Operator.new(FactoryBot.attributes_for(:employee, :operator, cvn_validation_date: nil))

      expect(operator).to be_invalid
    end
  end
end
