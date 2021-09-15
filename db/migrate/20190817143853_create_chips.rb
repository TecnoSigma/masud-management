class CreateChips < ActiveRecord::Migration[5.2]
  def change
    create_table :chips do |t|
      t.string :kind
      t.string :serial_number
      t.string :status, default: Status::STATUSES[:deactivated]
      t.boolean :functional, default: false
      t.boolean :configured, default: false
      t.date :acquisition_date

      t.references :kit, index: true

      t.timestamps
    end
  end
end
