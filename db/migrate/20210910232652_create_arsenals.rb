class CreateArsenals < ActiveRecord::Migration[6.1]
  def change
    create_table :arsenals do |t|
      t.references :employee, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
