class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :agency
      t.string :number

      t.references :seller, index: true
      t.references :bank, index: true

      t.timestamps
    end
  end
end
