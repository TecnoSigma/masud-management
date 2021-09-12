require 'rails_helper'

RSpec.describe Gun, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Gun' do
      gun = Gun.new

      expect(gun).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Gun' do
      gun = Gun.new

      expect(gun).to respond_to(:employee)
    end
  end
end
