require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it 'no validates when not pass department' do
    ticket = FactoryBot.build(:ticket, department: nil)

    expect(ticket).to be_invalid
    expect(ticket.errors[:department]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when not pass title' do
    ticket = FactoryBot.build(:ticket, subject: nil)

    expect(ticket).to be_invalid
    expect(ticket.errors[:subject]).to include('Preenchimento de campo obrigatório!')
  end

  context 'no validates when not pass responsible name' do
    it "and ticket status is 'em andamento'" do
      subscriber = FactoryBot.create(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber, responsible: nil, status: 'aberto')
      ticket.status = Status::TICKET_STATUSES[:in_treatment]

      expect(ticket).to be_invalid
    end

    it "and ticket status is 'aguardando resposta do a	ssinante'" do
      subscriber = FactoryBot.create(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber, responsible: nil, status: 'aberto')
      ticket.status = Status::TICKET_STATUSES[:waiting_subscriber]

      expect(ticket).to be_invalid
    end

    it "and ticket status is 'aguardando resposta da Protector-Angels'" do
      subscriber = FactoryBot.create(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber, responsible: nil, status: 'aberto')
      ticket.status = Status::TICKET_STATUSES[:waiting_company]

      expect(ticket).to be_invalid
    end

    it "and ticket status is 'finalizado'" do
      subscriber = FactoryBot.create(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber, responsible: nil, status: 'aberto')
      ticket.status = Status::TICKET_STATUSES[:finished]

      expect(ticket).to be_invalid
    end

    it "and ticket status is 'concluído'" do
      subscriber = FactoryBot.create(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber, responsible: nil, status: 'aberto')
      ticket.status = Status::TICKET_STATUSES[:closed]

      expect(ticket).to be_invalid
    end

    it "and ticket status is 'recorrência'" do
      subscriber = FactoryBot.create(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber, responsible: nil, status: 'aberto')
      ticket.status = Status::TICKET_STATUSES[:recurrence]

      expect(ticket).to be_invalid
    end
  end

  it 'no validates when not pass status' do
    ticket = FactoryBot.build(:ticket, status: nil)

    expect(ticket).to be_invalid
    expect(ticket.errors[:status]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when pass an invalid status to a new ticket' do 
    ticket = FactoryBot.build(:ticket, status: 'Finalizado')

    expect(ticket).to be_invalid
  end

  it 'no validates a new ticket when pass as delayed' do
    ticket = FactoryBot.build(:ticket, delayed: true)

    expect(ticket).to be_invalid
  end

  it 'no validates a new ticket when pass as finished' do
    ticket = FactoryBot.build(:ticket, finished: true)

    expect(ticket).to be_invalid
  end

  it 'no validates a new ticket when pass as recurrent' do
    ticket = FactoryBot.build(:ticket, recurrence: true)

    expect(ticket).to be_invalid
  end

  describe 'validates relationships' do
    it 'validates relationship 1:N between Ticket and Comment' do
      ticket = Ticket.new

      expect(ticket).to respond_to(:comments)
    end

    it 'validates relationship N:1 between Ticket and Subscriber' do
      ticket = Ticket.new

      expect(ticket).to respond_to(:subscriber)
    end
  end
end
