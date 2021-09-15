class Freight
  def self.cnpj
    ENV['CNPJ'].gsub('.', '').gsub('/', '').gsub('-', '')
  end

  def self.postal_code
    format_postal_code(ENV['POSTAL_CODE']).gsub('-', '')
  end

  def self.format_postal_code(postal_code)
    postal_code.gsub('-', '')
  end

  def self.calculate(postal_code:, price:, quantity:)
    freight = Gateways::Delivery::Freight
                .calculate(postal_code: postal_code,
                           price: price.to_f,
                           quantity: quantity)

    '%.2f' % (freight[:frete][0][:vltotal] * (1 - APP_CONFIG[:freight][:discount]))
  rescue => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    '0.00'
  end
end
