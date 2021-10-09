# frozen_string_literal: true

module Regex
  class << self
    def cnpj
      /\A^([0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}|[0-9]{2}\.?[0-9]{3}\.?[0-9]{3}\/?[0-9]{4}\-?[0-9]{2})$\z/
    end

    def telephone
      /\A^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$\z/
    end
  end
end
