module States
  ALL_STATES_WITH_FEDERATIVE_UNITS = [%w[AC Acre],
                                      %w[AL Alagoas],
                                      %w[AP Amapá],
                                      %w[AM Amazonas],
                                      %w[BA Bahia],
                                      %w[CE Ceará],
                                      ['DF', 'Distrito Federal'],
                                      ['ES', 'Espírito Santo'],
                                      %w[GO Goiás],
                                      %w[MA Maranhão],
                                      ['MT', 'Mato Grosso'],
                                      ['MS', 'Mato Grosso do Sul'],
                                      ['MG', 'Minas Gerais'],
                                      %w[PR Paraná],
                                      %w[PB Paraíba],
                                      %w[PA Pará],
                                      %w[PE Pernambuco],
                                      %w[PI Piauí],
                                      ['RS', 'Rio Grance do Sul'],
                                      ['RN', 'Rio Grande do Norte'],
                                      ['RJ', 'Rio de Janeiro'],
                                      %w[RO Rondônia],
                                      %w[RR Roraima],
                                      ['SC', 'Santa Catarina'],
                                      %w[SE Sergipe],
                                      ['SP', 'São Paulo'],
                                      %w[TO Tocantins]].freeze
  class << self
    def all_names
      ALL_STATES_WITH_FEDERATIVE_UNITS.map { |state| state.last }
    end

    def state_name(federative_unit)
      ALL_STATES_WITH_FEDERATIVE_UNITS.each do |state|
        return state.last if state.include?(federative_unit)
      end
    end

    def federative_unit(state_name)
      ALL_STATES_WITH_FEDERATIVE_UNITS.each do |state|
        return state.first if state.include?(state_name)
      end
    end
  end
end

