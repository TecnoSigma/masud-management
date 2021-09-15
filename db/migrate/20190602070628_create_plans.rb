class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :code
      t.float :price, default: 0.00
      t.string :status

      t.timestamps
    end
  end
end
