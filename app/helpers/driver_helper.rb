module DriverHelper
  def rate(driver)
    "#{Rating.average(driver)}/#{Rating::DEFAULT_RATE}"
  end
end
