class CreateDrivers < ActiveRecord::Migration[8.1]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :license_number

      t.timestamps
    end
    add_index :drivers, :license_number
  end
end
