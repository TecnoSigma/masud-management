class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.float :rate, default: Rating::DEFAULT_RATE
      t.string :comment
      t.references :driver, index: true

      t.timestamps
    end
  end
end
