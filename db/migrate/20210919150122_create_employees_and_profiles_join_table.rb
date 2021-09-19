class CreateEmployeesAndProfilesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :employees, :profiles do |t|
      t.index :employee_id
      t.index :profile_id
    end
  end
end
