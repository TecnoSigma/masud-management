class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :department
      t.string :responsible
      t.string :subject
      t.string :status, default: Status::STATUSES[:opened]
      t.boolean :delayed, default: false
      t.boolean :finished, default: false
      t.boolean :recurrence, default: false
      t.references :subscriber, index: true
      t.timestamps
    end
  end
end
