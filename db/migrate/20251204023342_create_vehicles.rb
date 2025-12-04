class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :model
      t.integer :status

      t.timestamps
    end
    add_index :vehicles, :license_plate
  end
end
