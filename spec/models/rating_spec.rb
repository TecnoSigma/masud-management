require 'rails_helper'

RSpec.describe Rating, type: :model do
  it 'does not validate when pass rate as null' do
    rating = FactoryBot.build(:rating, rate: nil)

    expect(rating).to be_invalid
    expect(rating.errors[:rate]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate without comment when rate less than 50% of maximum rate' do
    rating = FactoryBot.build(:rating, rate: 4.99999, comment: nil)

    expect(rating).to be_invalid
    expect(rating.errors[:comment]).to include('Preenchimento de campo obrigatório!')
  end

  describe 'validates relationships' do
    it 'validates relationship (N:1) between ratings and driver' do
      rating = FactoryBot.build(:rating)

      expect(rating).to respond_to(:driver)
    end
  end

  describe '.average' do
    it 'calculates simple average of driver rates' do
      driver = FactoryBot.create(:driver)

      rating_1 = FactoryBot.create(:rating, driver: driver)
      rating_1.rate = 5.0
      rating_1.save!

      rating_2 = FactoryBot.create(:rating, driver: driver)
      rating_2.rate = 7.0
      rating_2.save!

      rating_3 = FactoryBot.create(:rating, driver: driver)
      rating_3.rate = 3.0
      rating_3.comment = 'any text'
      rating_3.save!

      rating_4 = FactoryBot.create(:rating, driver: driver)
      rating_4.rate = 4.0
      rating_4.comment = 'any text'
      rating_4.save!

      expect(described_class.average(driver)).to eq(4.75)
    end

    it 'retuns default rate when occurs some errors' do
      driver = FactoryBot.create(:driver)

      rating = FactoryBot.create(:rating, driver: driver)
      rating.rate = 5.0
      rating.save!

      allow(driver).to receive(:ratings) { raise StandardError }

      expect(described_class.average(driver)).to eq(10.0)
    end
  end
end
