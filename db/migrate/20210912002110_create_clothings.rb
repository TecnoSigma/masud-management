class CreateClothings < ActiveRecord::Migration[5.2]
  def change
    create_table :clothings do |t|
      t.references :employee, index: true
      t.string :kind
      t.references :status, index: true

      t.timestamps
    end
  end
end
