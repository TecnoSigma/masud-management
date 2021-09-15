class CreateAngels < ActiveRecord::Migration[5.2]
  def change
    create_table :angels do |t|
      t.string :name
      t.string :cpf
      t.string :status, default: Status::STATUSES[:activated]
      t.references :subscriber, index: true

      t.timestamps
    end
  end
end
