# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemMovimentation, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between ItemMovimentation and Arsenal' do
      item_movimentation = ItemMovimentation.new

      expect(item_movimentation).to respond_to(:arsenal)
    end

    it 'validates relationship (N:1) between ItemMovimentation and Tackle' do
      item_movimentation = ItemMovimentation.new

      expect(item_movimentation).to respond_to(:tackle)
    end

    it 'validates relationship (N:1) between ItemMovimentation and Vehicle' do
      item_movimentation = ItemMovimentation.new

      expect(item_movimentation).to respond_to(:vehicle)
    end
  end
end
