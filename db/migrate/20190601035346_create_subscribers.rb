class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.string :code
      t.string :name
      t.string :responsible_cpf
      t.string :responsible_name
      t.string :document
      t.string :kind
      t.string :address
      t.string :number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :ip
      t.string :email
      t.string :telephone
      t.string :cellphone
      t.string :user
      t.string :password
      t.string :status
      t.date :deleted_at
      t.references :plan, index: true

      t.timestamps
    end
  end
end
