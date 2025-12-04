class CreateManifestos < ActiveRecord::Migration[8.1]
  def change
    create_table :manifestos do |t|
      t.date :date
      t.references :driver, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.integer :status
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
