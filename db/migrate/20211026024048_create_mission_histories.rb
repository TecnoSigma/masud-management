class CreateMissionHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :mission_histories do |t|
      t.string :team
      t.string :agents
      t.string :items
      t.references :mission, index: true

      t.timestamps
    end
  end
end
