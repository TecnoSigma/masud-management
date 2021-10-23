# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#date_time' do
    it 'convert to date/time of job' do
      order = FactoryBot.create(:order, :scheduled)

      expected_result = "#{order.job_day} - #{order.job_horary}"

      result = helper.date_time(order)

      expect(result).to eq(expected_result)
    end
  end
end
