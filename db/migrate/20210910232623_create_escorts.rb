class CreateEscorts < ActiveRecord::Migration[5.2]
  def change
    create_table :escorts do |t|
      t.references :customer, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
