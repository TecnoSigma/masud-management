module KitItemCallBacks
  CHIP = 'Chip'.freeze

  def self.included(base)
    base.before_save :default_serial_number
    base.before_save :default_acquisition_date

    base.validate :check_initial_status
    base.validate :check_allowed_status
    base.validate :check_initial_configured_field
    base.validate :check_initial_functional_field
    base.validate :check_initial_acquisition_date
  end

  def default_acquisition_date
    self.acquisition_date || self.acquisition_date = DateTime.now
  end

  def default_serial_number
    serial_number = self.class.name == CHIP ?
                      "#{rand(10_000).to_s.rjust(4,'0')} " \
                      "#{rand(10_000).to_s.rjust(4,'0')} " \
                      "#{rand(10_000).to_s.rjust(4,'0')} " \
                      "#{rand(10_000).to_s.rjust(4,'0')} " :
                      SecureRandom.uuid.upcase.remove('-')

    self.serial_number || self.serial_number = serial_number
  end

  def check_initial_configured_field
    return if self.persisted?

    errors.add(:configured, Messages::errors[:invalid_data]) if self.configured
  end

  def check_initial_functional_field
    return if self.persisted?

    errors.add(:functional, Messages::errors[:invalid_data]) if self.functional
  end

  def check_initial_acquisition_date
    return if self.persisted? || self.acquisition_date.nil?

    if self.acquisition_date > DateTime.now
      errors.add(:acquisition_date, Messages::errors[:invalid_date])
    end
  end

  def check_initial_status
    return if self.persisted?

    unless self.status == Status::STATUSES[:deactivated]
      errors.add(:status, Messages::errors[:invalid_status])
    end
  end

  def check_allowed_status
    if [Status::STATUSES[:activated], Status::STATUSES[:deactivated]].exclude?(self.status)
      errors.add(:status, Messages::errors[:invalid_status])
    end
  end
end
