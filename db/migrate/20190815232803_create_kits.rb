class CreateKits < ActiveRecord::Migration[5.2]
  def change
    create_table :kits do |t|
      t.string :serial_number
      
      t.references :subscriber, index: true

      t.timestamps
    end
  end
end
