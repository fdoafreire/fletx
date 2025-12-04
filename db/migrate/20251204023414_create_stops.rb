class CreateStops < ActiveRecord::Migration[8.1]
  def change
    create_table :stops do |t|
      t.references :manifesto, null: false, foreign_key: true
      t.string :address
      t.integer :order
      t.integer :stop_type
      t.integer :status
      t.datetime :completed_at

      t.timestamps
    end
  end
end
