class CreateRouters < ActiveRecord::Migration[5.2]
  def change
    create_table :routers do |t|
      t.string :operator
      t.string :kind
      t.string :serial_number
      t.string :user
      t.string :password
      t.string :imei
      t.string :status, default: Status::STATUSES[:deactivated]
      t.boolean :functional, default: false
      t.boolean :configured, default: false
      t.date :acquisition_date

      t.references :kit, index: true

      t.timestamps
    end
  end
end
