class CreateItemMovimentations < ActiveRecord::Migration[5.2]
  def change
    create_table :item_movimentations do |t|
      t.boolean :input, default: false
      t.boolean :output, default: false
      t.integer :quantity, default: 0
      t.references :arsenal, index: true
      t.references :tackle, index: true
      t.references :vehicle, index: true

      t.timestamps
    end
  end
end
