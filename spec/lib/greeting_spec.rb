# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Greeting do
  describe '.greet' do
    it 'returns \'Bom dia \' when ois morning' do
      allow(Time).to receive_message_chain(:zone, :now, :hour) { 5 }

      result = described_class.greet

      expect(result).to eq('Bom dia')
    end

    it 'returns \'Boa tarde\' when is afternoon' do
      allow(Time).to receive_message_chain(:zone, :now, :hour) { 14 }

      result = described_class.greet

      expect(result).to eq('Boa tarde')
    end

    it 'returns \'Boa noite\' when is night' do
      allow(Time).to receive_message_chain(:zone, :now, :hour) { 20 }

      result = described_class.greet

      expect(result).to eq('Boa noite')
    end

    it 'returns \'Olá\' when is generic time' do
      allow(Time).to receive_message_chain(:zone, :now, :hour) { 25 }

      result = described_class.greet

      expect(result).to eq('Olá')
    end
  end
end
