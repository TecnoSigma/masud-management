class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :type
      t.string :order_number
      t.datetime :job_day
      t.string :source_address
      t.string :source_number
      t.string :source_complement
      t.string :source_district
      t.string :source_city
      t.string :source_state
      t.string :destiny_address
      t.string :destiny_number
      t.string :destiny_complement
      t.string :destiny_district
      t.string :destiny_city
      t.string :destiny_state
      t.string :observation
      t.string :reason
      t.references :customer, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
