class AddDriverRefToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_reference :vehicles, :driver, null: false, foreign_key: true
  end
end
