class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :code
      t.float :price
      t.string :status, default: Status::ORDER_STATUSES[:pendent]
      t.datetime :approved_at
      t.references :subscription, index: true
      t.references :seller, index: true

      t.timestamps
    end
  end
end
