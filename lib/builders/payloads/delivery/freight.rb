module Builders
  module Payloads
    module Delivery
      class Freight
        class << self
          def data(destiny_postal_code:, price:, quantity: 1)
            { frete: 
              [ { cepori: ::Freight.postal_code,                             # CEP de origem
                  cepdes: ::Freight.format_postal_code(destiny_postal_code), # CEP de destino
                  frap: APP_CONFIG[:freight][:frap],                         # Cobrança de frete no destino
                  peso: total_weight(quantity),                              # Peso total a ser transportado
                  cnpj: ::Freight.cnpj,                                      # CNPJ do tomador do serviço
                  conta: ENV['JADLOG_ACCOUNT'],                              # Número conta corrente JadLog
                  contrato: ENV['JADLOG_CONTRACT'],                          # Número do contrato JadLog
                  modalidade: APP_CONFIG[:freight][:modality],               # Modalidade de transporte
                  tpentrega: APP_CONFIG[:freight][:delivery_type],           # Tipo de entrega
                  tpseguro: APP_CONFIG[:freight][:insurance_type],           # Tipo do seguro
                  vldeclarado: price,                                        # Valor declarado de Nota Fiscal
                  vlcoleta: APP_CONFIG[:freight][:collection_value] }        # Valor de coleta negociado com JadLog
              ]
            }
          end

          def total_weight(quantity)
            APP_CONFIG[:freight][:weight] * quantity
          end
        end

        private_class_method :total_weight
      end
    end
  end
end
