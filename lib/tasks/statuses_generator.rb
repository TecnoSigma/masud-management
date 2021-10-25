# frozen_string_literal: true

require 'csv'

module Tasks
  class StatusesGenerator
    class << self
      STATUSES_LIST = ["agendado",
                       "ativo",
                       "cancelada",
                       "cancelado pelo cliente",
                       "confirmado",
                       "deletado",
                       "desativado",
                       "desligado",
                       "em andamento",
                       "finalizada",
                       "iniciada",
                       "irregular",
                       "pendente",
                       "recusado",
                       "regular",
                       "suspenso"].freeze

      private_constant :STATUSES_LIST

      def call!
        sleep(2)

        STATUSES_LIST.each do |status|
          Status.create!(name: status)

          puts "--- Status #{status} created!"
        end

        puts "-- #{Status.count} statuses created!"
      end
    end
  end
end
