require 'rails_helper'

RSpec.describe Status, type: :model do
  it 'returns hash containing allowed statuses' do
    expected_result = { activated: 'ativado',
                        pendent: 'pendente',
                        deactivated: 'desativado',
                        deleted: 'deletado',
                        cancelled_by_company: 'cancelado pela empresa',
                        cancelled_by_subscriber: 'cancelado pelo assinante' }

    expect(Status::STATUSES).to eq(expected_result)
  end

  it 'returns hash containing allowed payment statuses' do
    expected_result = {activated: "ACTIVE", deactivated: "SUSPENDED"}

    expect(Status::PAYMENT_STATUSES).to eq(expected_result)
  end

  it 'returns hash containing allowed vehicle statuses' do
    expected_result = { activated: 'ativado', without_photos: 'sem fotos' }

    expect(Status::VEHICLE_STATUSES).to eq(expected_result)
  end

  it 'returns hash containing allowed ticket statuses' do
    expected_result = { closed: 'concluído',
                        finished: 'finalizado',
                        in_treatment: 'em andamento',
                        opened: 'aberto',
                        recurrence: 'reincidente',
                        waiting_company: 'aguardando resposta da Protector-Angels',
                        waiting_subscriber: 'aguardando resposta do assinante' }

    expect(Status::TICKET_STATUSES).to eq(expected_result)
  end

  it 'returns hash containing allowed order statuses' do
    expected_result = { pendent: 'pendente',
                        approved: 'aprovado',
                        refused: 'recusado' }

    expect(Status::ORDER_STATUSES).to eq(expected_result)
  end
end
