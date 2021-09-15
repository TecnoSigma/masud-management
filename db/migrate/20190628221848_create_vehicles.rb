class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :kind
      t.string :license_plate
      t.string :status, default: Status::STATUSES[:activated]
      t.references :subscriber, index: true

      t.timestamps
    end
  end
end
