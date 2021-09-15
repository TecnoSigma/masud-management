module Tributes
  class Inss
    ALIQUOTS = { first_aliquot: { percentage: 0.075,
                                  tread: 0.00,
                                  ceiling: 1044.99 },
                 second_aliquot: { percentage: 0.09,
                                   tread: 1045.0,
                                   ceiling: 2089.60 },
                 third_aliquot: { percentage: 0.12,
                                  tread: 2089.61,
                                  ceiling: 3134.40 },
                 forth_aliquot: { percentage: 0.14,
                                  tread: 3134.41,
                                  ceiling: 6101.06 } }.freeze

    EMPLOYER_INSS_PERCENTAGE = 0.2.freeze

    private_constant :ALIQUOTS, :EMPLOYER_INSS_PERCENTAGE

    def self.employers(value)
      (value * EMPLOYER_INSS_PERCENTAGE).round(2)
    end

    def self.employee(value)
      value = value.to_f
      first_aliquot = ALIQUOTS[:first_aliquot]
      second_aliquot = ALIQUOTS[:second_aliquot]
      third_aliquot = ALIQUOTS[:third_aliquot]
      forth_aliquot = ALIQUOTS[:forth_aliquot]

      return calc_first_aliquot(value) if inside_range?(value, first_aliquot)
      return calc_second_aliquot(value) if inside_range?(value, second_aliquot)
      return calc_third_aliquot(value) if inside_range?(value, third_aliquot)
      return calc_forth_aliquot(value) if inside_range?(value, forth_aliquot)

      calc_forth_aliquot(ALIQUOTS[:forth_aliquot][:ceiling])
    end

    def self.inside_range?(value, aliquot)
      value >= aliquot[:tread] && value <= aliquot[:ceiling]
    end

    def self.calculate(value:, aliquot:)
      (value * aliquot).round(2)
    end

    def self.calc_first_aliquot(value)
      calculate(value: value, aliquot: ALIQUOTS[:first_aliquot][:percentage])
    end

    def self.calc_second_aliquot(value)
      calculate(value: value, aliquot: ALIQUOTS[:second_aliquot][:percentage])
    end

    def self.calc_third_aliquot(value)
      calculate(value: value, aliquot: ALIQUOTS[:third_aliquot][:percentage])
    end

    def self.calc_forth_aliquot(value)
      calculate(value: value, aliquot: ALIQUOTS[:forth_aliquot][:percentage])
    end

    private_class_method :calculate,
                         :calc_first_aliquot,
                         :calc_second_aliquot,
                         :calc_third_aliquot,
                         :calc_forth_aliquot,
                         :inside_range?
  end
end
