class CreateTackles < ActiveRecord::Migration[5.2]
  def change
    create_table :tackles do |t|
      t.string :type
      t.references :employee, index: true
      t.references :status, index: true
      t.timestamps

      # Radio, Waistcoat
      t.string :serial_number

      # Waistcoat
      t.string :register_number
      t.string :brand
      t.date :fabrication_date
      t.date :validation_date
      t.date :bond_date
      t.string :protection_level
      t.string :situation
    end
  end
end
