class CreateDriversAndVehiclesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :drivers, :vehicles do |t| 
      t.index :driver_id
      t.index :vehicle_id
    end 
  end 
end

