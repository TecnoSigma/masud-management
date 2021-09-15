class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :code
      t.string :status
      t.integer :vehicles_amount, default: 0
      t.references :subscriber, index: true

      t.timestamps
    end
  end
end
