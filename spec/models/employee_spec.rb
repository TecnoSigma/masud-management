require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Employee' do
      employee = Employee.new

      expect(employee).to respond_to(:status)
    end
  end
end
