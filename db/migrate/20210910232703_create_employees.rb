class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :email
      t.string :password
      t.references :team, index: true
      t.references :status, index: true
      t.timestamps
    end
  end
end
