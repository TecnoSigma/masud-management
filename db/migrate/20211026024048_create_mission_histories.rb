class CreateMissionHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :mission_histories do |t|
      t.string :team
      t.text :agents, array: true, default: []
      t.text :items, array: true, default: []
      t.references :mission, index: true

      t.timestamps
    end
  end
end
