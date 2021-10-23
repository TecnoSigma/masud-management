# frozen_string_literal: true

class Munition < Arsenal
  validates :kind,
            :quantity,
            presence: true

  def available
    return quantity unless item_movimentations

    input_sum = item_movimentations.where(input: true).sum(:quantity)
    output_sum = item_movimentations.where(output: true).sum(:quantity)

    quantity - (output_sum - input_sum)
  end
end
