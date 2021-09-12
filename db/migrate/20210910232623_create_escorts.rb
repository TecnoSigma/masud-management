class CreateEscorts < ActiveRecord::Migration[6.1]
  def change
    create_table :escorts do |t|
      t.references :customer, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
