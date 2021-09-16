# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Waistcoat, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Waistcoat' do
      waistcoat = Waistcoat.new

      expect(waistcoat).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Waistcoat' do
      waistcoat = Waistcoat.new

      expect(waistcoat).to respond_to(:employee)
    end
  end

  it 'validates inheritance of Waistcoat with Clothing' do
    expect(described_class).to be < Clothing
  end
end
