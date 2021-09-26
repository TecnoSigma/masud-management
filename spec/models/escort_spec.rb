# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Escort, type: :model do
  it 'validates inheritance of Escort with Service' do
    expect(described_class).to be < Service
  end
end
