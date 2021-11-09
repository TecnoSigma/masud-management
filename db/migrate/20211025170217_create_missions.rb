class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.datetime :exit_from_base
      t.datetime :arrival_at_base
      t.datetime :started_at
      t.datetime :finished_at
      t.string :observation
      t.references :team, index: true
      t.references :escort_service, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
