# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Status, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (1:N) between Status and Customer' do
      status = Status.new

      expect(status).to respond_to(:customers)
    end

    it 'validates relationship (1:N) between Status and Tackle' do
      status = Status.new

      expect(status).to respond_to(:tackles)
    end

    it 'validates relationship (1:N) between Status and Employee' do
      status = Status.new

      expect(status).to respond_to(:employees)
    end

    it 'validates relationship (1:N) between Status and Escort' do
      status = Status.new

      expect(status).to respond_to(:escorts)
    end

    it 'validates relationship (1:N) between Status and Vehicle' do
      status = Status.new

      expect(status).to respond_to(:vehicles)
    end

    it 'validates relationship (1:N) between Status and Arsenal' do
      status = Status.new

      expect(status).to respond_to(:arsenals)
    end

    it 'validates relationship (1:N) between Status and Clothing' do
      status = Status.new

      expect(status).to respond_to(:clothes)
    end
  end

  it 'validates presence of name' do
    status = FactoryBot.build(:status, name: nil)

    expect(status).to be_invalid
  end
end
