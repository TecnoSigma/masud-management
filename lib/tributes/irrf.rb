module Tributes
  class Irrf
    ALIQUOTS = { first_aliquot: { percentage: 0,
                                  tread: 0.00,
                                  ceiling: 1903.98,
                                  deduction: 0.00 },
                 second_aliquot: { percentage: 0.075,
                                   tread: 1903.99,
                                   ceiling: 2826.65,
                                   deduction: 142.80 },
                 third_aliquot: { percentage: 0.15,
                                  tread: 2826.66,
                                  ceiling: 3751.05,
                                  deduction: 354.80 },
                 forth_aliquot: { percentage: 0.225,
                                  tread: 3751.06,
                                  ceiling: 4664.68,
                                  deduction: 636.13 },
                 fifth_aliquot: { percentage: 0.275,
                                  ceiling: 4664.69,
                                  deduction: 869.36 } }.freeze

    private_constant :ALIQUOTS

    def self.employee(value)
      second_aliquot = ALIQUOTS[:second_aliquot]
      third_aliquot = ALIQUOTS[:third_aliquot]
      forth_aliquot = ALIQUOTS[:forth_aliquot]

      return zeroed_value if inside_range?(value, ALIQUOTS[:first_aliquot])
      return calc(value, second_aliquot) if inside_range?(value, second_aliquot)
      return calc(value, third_aliquot) if inside_range?(value, third_aliquot)
      return calc(value, forth_aliquot) if inside_range?(value, forth_aliquot)

      calc(value, ALIQUOTS[:fifth_aliquot])
    end

    def self.calc(value, aliquot)
      remuneration = value.to_f - Tributes::Inss.employee(value.to_f)

      ((remuneration * aliquot[:percentage]) - aliquot[:deduction]).round(2)
    end

    def self.inside_range?(value, aliquot)
      remuneration = value.to_f - Tributes::Inss.employee(value.to_f)

      remuneration >= aliquot[:tread] && remuneration <= aliquot[:ceiling]
    end

    def self.zeroed_value
      0.00
    end

    private_class_method :calc, :inside_range?, :zeroed_value
  end
end
