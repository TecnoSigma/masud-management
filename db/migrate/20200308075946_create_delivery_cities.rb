class CreateDeliveryCities < ActiveRecord::Migration[5.2]
  def change
    create_table :delivery_cities do |t|
      t.string :federative_unit
      t.string :locality
      t.string :initial_postal_code
      t.string :final_postal_code
      t.integer :express_time
      t.integer :road_time
      t.string :price
      t.string :destiny_freight
      t.string :distributor
      t.string :redispatch
      t.integer :risk_group
    end
  end
end
