module ApplicationHelper
  def convert_float_to_currency(value)
    number_to_currency(value, unit: 'R$ ', separator: ',', delimiter: '.')
  end

  def month_list
    [*(1..12)].map { |day| day.to_s.rjust(2, '0') }
  end

  def year_list
    current_year = DateTime.now.year

    [*(current_year..(current_year + 20))]
  end

  def convert_date(date)
    date.strftime('%d/%m/%Y - %H:%M:%S') 
  end

  def formatted_date(date)
    convert_date(date)
      .split(' - ')
      .first
  end

  def extensive_number(number)
    converted_in_cents = (number * 100).to_i
    Extenso.moeda(converted_in_cents).downcase
  end

  def leading_zeros(number:, leading_zeros:)
    "%0#{leading_zeros}d" % number
  end
end
