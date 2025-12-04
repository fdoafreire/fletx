class AddStatusToDrivers < ActiveRecord::Migration[8.1]
  def change
    add_column :drivers, :status, :integer
  end
end
