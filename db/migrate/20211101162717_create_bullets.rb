class CreateBullets < ActiveRecord::Migration[5.2]
  def change
    create_table :bullets do |t|
      t.integer :quantity
      t.string :caliber
      t.references :employee, index: true

      t.timestamps
    end
  end
end
