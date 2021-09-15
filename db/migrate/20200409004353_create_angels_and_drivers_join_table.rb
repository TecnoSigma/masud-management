class CreateAngelsAndDriversJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :angels, :drivers do |t|
      t.index :angel_id
      t.index :driver_id
    end
  end
end
