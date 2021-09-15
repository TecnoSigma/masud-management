require "rails_helper"

RSpec.describe Notifications::Hiring, type: :mailer do
  describe 'renders the headers' do
    it 'renders #to' do
      subscriber = { 'name' => 'Maria da Silva', 'email' =>'maria.silva@any.com.br' }

      result = described_class.finalization(subscriber).to

      expect(result).to eq([subscriber['email']])
    end

    it 'renders #subject' do
      subscriber = { 'name' => 'Maria da Silva', 'email' =>'maria.silva@any.com.br' }
      
      result = described_class.finalization(subscriber).subject

      expect(result).to eq('Benvindo à Protector Angels!')
    end

    it 'renders #from' do
      subscriber = { 'name' => 'Maria da Silva', 'email' =>'maria.silva@any.com.br' }

      result = described_class.finalization(subscriber).from

      expect(result).to eq(['tecnooxossi@gmail.com'])
    end
  end
end
