class CreateReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :receipts do |t|
      t.string :serial, default: Receipt::SERIAL
      t.jsonb :credits
      t.jsonb :debits
      t.string :period
      t.references :seller, index: true

      t.timestamps
    end
  end
end
