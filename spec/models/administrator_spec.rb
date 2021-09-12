require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Administrator' do
      administrator = Administrator.new

      expect(administrator).to respond_to(:status)
    end
  end

  it 'validates inheritance of Administrator with Employee' do
    expect(described_class).to be < Employee
  end
end
