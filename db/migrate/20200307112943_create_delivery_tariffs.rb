class CreateDeliveryTariffs < ActiveRecord::Migration[5.2]
  def change
    create_table :delivery_tariffs do |t|
      t.string :federative_unit
      t.string :destiny
      t.string :kind
      t.float :kg_1
      t.float :kg_2
      t.float :kg_3
      t.float :kg_4
      t.float :kg_5
      t.float :kg_6
      t.float :kg_7
      t.float :kg_8
      t.float :kg_9
      t.float :kg_10
      t.float :kg_11
      t.float :kg_12
      t.float :kg_13
      t.float :kg_14
      t.float :kg_15
      t.float :kg_16
      t.float :kg_17
      t.float :kg_18
      t.float :kg_19
      t.float :kg_20
      t.float :kg_21
      t.float :kg_22
      t.float :kg_23
      t.float :kg_24
      t.float :kg_25
      t.float :kg_26
      t.float :kg_27
      t.float :kg_28
      t.float :kg_29
      t.float :kg_30
      t.float :additional_kg
    end
  end
end
