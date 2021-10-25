class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.datetime :started_at
      t.datetime :finished_at
      t.references :team, index: true
      t.references :escort_service, index: true
      t.references :status, index: true

      t.timestamps
    end
  end
end
