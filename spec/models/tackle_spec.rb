# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tackle, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Tackle' do
      tackle = Tackle.new

      expect(tackle).to respond_to(:status)
    end
  end
end
