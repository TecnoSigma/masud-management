class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :codename
      t.date :admission_date
      t.date :resignation_date
      t.string :cvn_number
      t.date :cvn_validation_date
      t.string :rg
      t.string :cpf
      t.string :email
      t.string :password
      t.references :team, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
