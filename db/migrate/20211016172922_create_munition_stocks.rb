class CreateMunitionStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :munition_stocks do |t|
      t.string :caliber
      t.integer :quantity, default: 0
      t.datetime :last_update
    end
  end
end
