require "rails_helper"

RSpec.describe Documents::Distract, type: :mailer do
  describe 'checks headers' do
    context 'when user is a seller' do
      it 'renders recipient' do
        seller = FactoryBot.create(:seller)

        result = described_class.send_document(seller).to

        expect(result).to eq([seller.email])
      end

      it 'renders subject' do
        seller = FactoryBot.create(:seller)

        result = described_class.send_document(seller).subject

        expect(result).to eq('Envio de Documentação (Distrato)')
      end

      it 'renders sender' do
        seller = FactoryBot.create(:seller)

        result = described_class.send_document(seller).from

        expect(result).to eq(['tecnooxossi@gmail.com'])
      end
    end

    context 'when user is a subscriber' do
      it 'renders recipient' do
        subscriber = FactoryBot.create(:subscriber)

        result = described_class.send_document(subscriber).to

        expect(result).to eq([subscriber.email])
      end

      it 'renders subject' do
        subscriber = FactoryBot.create(:subscriber)

        result = described_class.send_document(subscriber).subject

        expect(result).to eq('Envio de Documentação (Distrato)')
      end

      it 'renders sender' do
        subscriber = FactoryBot.create(:subscriber)

        result = described_class.send_document(subscriber).from

        expect(result).to eq(['tecnooxossi@gmail.com'])
      end
    end
  end
end
