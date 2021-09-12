require 'rails_helper'

RSpec.describe Approver, type: :model do
  it 'validates inheritance of Approver with Employee' do
    expect(described_class).to be < Employee
  end

  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Approver' do
      approver = Approver.new

      expect(approver).to respond_to(:status)
    end
  end
end
