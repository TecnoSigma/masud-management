class CreateTackles < ActiveRecord::Migration[5.2]
  def change
    create_table :tackles do |t|
      t.string :type
      t.string :serial_number
      t.references :employee, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
