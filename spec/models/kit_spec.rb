require 'rails_helper'

RSpec.describe Kit, type: :model do
  it 'validates when not pass subscriber' do
    kit = FactoryBot.build(:kit, subscriber: nil)

    expect(kit).to be_valid 
  end

  it 'validate relationship (1:1) between Kit and Subscriber' do
    kit = Kit.new

    expect(kit).to respond_to(:subscriber)
  end

  it 'validate relationship (1:1) between Kit and Camera' do
    kit = Kit.new

    expect(kit).to respond_to(:camera)
  end 

  it 'validate relationship (1:1) between Kit and Router' do
    kit = Kit.new

    expect(kit).to respond_to(:router)
  end 

  it 'validate relationship (1:1) between Kit and Chip' do
    kit = Kit.new

    expect(kit).to respond_to(:chip)
  end

  it 'creates a serial number of kit when not pass serial number' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber, serial_number: nil)

    expect(kit.serial_number).to be_present
  end
end
