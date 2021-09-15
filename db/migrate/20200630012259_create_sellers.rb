class CreateSellers < ActiveRecord::Migration[5.2]
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :code
      t.string :core_register
      t.datetime :expedition_date
      t.datetime :expiration_date
      t.string :password
      t.string :document
      t.string :cellphone
      t.string :email
      t.string :linkedin
      t.string :address
      t.string :number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :status, default: Status::STATUSES[:pendent]
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
