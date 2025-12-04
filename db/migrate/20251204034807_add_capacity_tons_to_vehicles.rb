class AddCapacityTonsToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_column :vehicles, :capacity_tons, :float
  end
end
