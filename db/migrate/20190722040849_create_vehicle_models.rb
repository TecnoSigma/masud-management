class CreateVehicleModels < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicle_models do |t|
      t.string :kind
      t.references :vehicle_brand, index: true

      t.timestamps
    end
  end
end
