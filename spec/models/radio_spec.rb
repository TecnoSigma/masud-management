# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Radio, type: :model do
  describe 'validates presences' do
    it 'of serial_number' do
      radio = FactoryBot.build(:tackle, :radio, serial_number: nil)

      expect(radio).to be_invalid
    end
  end
end
