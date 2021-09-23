class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :company
      t.string :cnpj
      t.string :email
      t.string :secondary_email
      t.string :tertiary_email
      t.string :telephone
      t.string :password
      t.references :status, index: true

      t.timestamps
    end
  end
end
