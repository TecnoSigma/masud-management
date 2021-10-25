class AgentAndMissionJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :agents_missions do |t|
      t.references :agent, index: true
      t.references :mission, index: true
    end
  end
end
