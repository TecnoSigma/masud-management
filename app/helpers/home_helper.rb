module HomeHelper
  def add_check(boolean)
    boolean == 'true' ? 'yes.svg' : 'no.svg'
  end

  def price(unit, cents)
    unit.to_f + (cents.to_f / 100)
  end
end
