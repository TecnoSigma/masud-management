class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :name
      t.integer :external_id
    end
  end
end
