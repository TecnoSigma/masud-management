# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clothing, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Clothing' do
      clothing = Clothing.new

      expect(clothing).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Clothing' do
      clothing = Clothing.new

      expect(clothing).to respond_to(:employee)
    end
  end
end
