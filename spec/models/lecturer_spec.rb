# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lecturer, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Lecturer' do
      lecturer = Lecturer.new

      expect(lecturer).to respond_to(:status)
    end
  end
end
