require 'rails_helper'

RSpec.describe Arsenal, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Arsenal' do
      arsenal= Arsenal.new

      expect(arsenal).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Arsenal' do
      arsenal = Arsenal.new

      expect(arsenal).to respond_to(:employee)
    end
  end
end
