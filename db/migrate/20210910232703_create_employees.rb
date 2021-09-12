class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.references :status, index: true
      t.string :kind
      t.references :team, index: true

      t.timestamps
    end
  end
end
