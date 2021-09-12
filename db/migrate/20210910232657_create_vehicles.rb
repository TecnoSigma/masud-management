class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles do |t|
      t.references :status, index: true

      t.timestamps
    end
  end
end
