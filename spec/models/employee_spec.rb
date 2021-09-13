# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Employee' do
      employee = Employee.new

      expect(employee).to respond_to(:status)
    end
  end

  describe 'validates presences' do
    it 'of email' do
      employee = FactoryBot.build(:employee, :administrator, email: nil)

      expect(employee).to be_invalid
    end

    it 'of password' do
      employee = FactoryBot.build(:employee, :administrator, password: nil)

      expect(employee).to be_invalid
    end
  end
end
