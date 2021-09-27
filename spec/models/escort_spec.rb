# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Escort, type: :model do
  it 'validates inheritance of Escort with Order' do
    expect(described_class).to be < Order
  end
end
