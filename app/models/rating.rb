class Rating < ApplicationRecord
  DEFAULT_RATE = 10.0
  LIMIT_LOW_RATE = 5.0

  validates :rate,
            presence: { message: Messages.errors[:required_field] }

  validate :check_comment_with_low_rate

  belongs_to :driver

  def check_comment_with_low_rate
    return unless self.rate

    if self.rate < LIMIT_LOW_RATE && self.comment.nil?
      errors.add(:comment, Messages.errors[:required_field])
    end
  end

  def self.average(driver)
    rates = driver.ratings.pluck(:rate)

    rates.inject(:+) / rates.count.to_f
  
  rescue StandardError => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    DEFAULT_RATE
  end
end

