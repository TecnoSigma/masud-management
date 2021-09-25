class CreateClothings < ActiveRecord::Migration[5.2]
  def change
    create_table :clothings do |t|
      t.string :type
      t.references :employee, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
