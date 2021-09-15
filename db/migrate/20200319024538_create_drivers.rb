class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :code
      t.string :license
      t.boolean :paid_activity, default: false
      t.datetime :expedition_date
      t.datetime :expiration_date
      t.string :status, default: Status::STATUSES[:activated]

      t.timestamps
    end
  end
end
