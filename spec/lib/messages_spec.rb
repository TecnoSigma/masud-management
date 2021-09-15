require 'rails_helper'

RSpec.describe Messages do
  describe '.all_names' do
    describe '.errors' do
      it 'returns hash containing errors messages' do
        expected_result = { required_field: "Preenchimento de campo obrigatório!",
                            invalid_rate: "Nota inicial inválida!",
                            invalid_characater_quantity: "Quantidade de caracteres inválidos!",
                            invalid_format: "Formato inválido!",
                            invalid_status: "Status inválido!",
                            invalid_plan_name: "Nome de plano inválido!",
                            invalid_price: "Preço inválido!",
                            invalid_user: "Usuário inválido!",
                            invalid_data: "Dados inválidos!",
                            invalid_date: "Data inválida!",
                            already_license_plate: "Placa existente!",
                            already_user: "Usuário existente!",
                            already_document: "Documento existente!",
                            already_core_register: "Código do CORE existente!",
                            already_plan_name: "Nome de plano existente!",
                            already_plan_code: "Código de plano existente!",
                            not_allowed_photo_quantity: "Quantidade de foto não permitida!"}

        expect(described_class.errors).to eq(expected_result)
      end
    end
  end
end
