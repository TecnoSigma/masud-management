class CreateServiceTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :service_tokens do |t|
      t.string :token
      t.references :customer, index: true
      t.references :employee, index: true

      t.timestamps
    end
  end
end
