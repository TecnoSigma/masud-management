# frozen_string_literal: true

module Greeting
  class << self
    def greet
      case Time.zone.now.hour
      when 4..11 then I18n.t('greeting.day')
      when 12..17 then I18n.t('greeting.afternoon')
      when 18..23 then I18n.t('greeting.night')
      else
        I18n.t('greeting.general')
      end
    end
  end
end
