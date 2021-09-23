class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :license_plate
      t.string :color
      t.references :status, index: true

      t.timestamps
    end
  end
end
