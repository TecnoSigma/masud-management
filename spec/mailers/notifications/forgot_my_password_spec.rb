require "rails_helper"

RSpec.describe Notifications::ForgotMyPassword, type: :mailer do
  describe 'renders the headers' do
    it 'renders #to' do
      subscriber = FactoryBot.create(:subscriber)
      
      result = described_class.send_password(subscriber).to

      expect(result).to eq([subscriber.email])
    end

    it 'renders #subject' do
      subscriber = FactoryBot.create(:subscriber)

      result = described_class.send_password(subscriber).subject

      expect(result).to eq('Envio de senha do dashboard')
    end

    it 'renders #from' do
      subscriber = FactoryBot.create(:subscriber)

      result = described_class.send_password(subscriber).from

      expect(result).to eq(['tecnooxossi@gmail.com'])
    end
  end
end
