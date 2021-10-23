# frozen_string_literal: true

class Munition < Arsenal
  validates :kind,
            :quantity,
            presence: true

  def self.available(kind)
    munition = find_by_kind(kind)

    return munition.quantity unless munition.item_movimentations

    input_sum = munition.item_movimentations.where(input: true).sum(:quantity)
    output_sum = munition.item_movimentations.where(output: true).sum(:quantity)

    munition.quantity - (output_sum - input_sum)
  end
end
