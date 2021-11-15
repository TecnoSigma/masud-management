class CreateArsenals < ActiveRecord::Migration[5.2]
  def change
    create_table :arsenals do |t|
      t.string :type
      t.references :employee, index: true
      t.references :status, index: true
      t.timestamps

      # Guns
      t.string :number
      t.string :kind
      t.string :caliber
      t.string :sinarm
      t.string :situation
      t.date :registration_validity
      t.boolean :linked_at_post, default: false
    end
  end
end
