class AddExpToJwtDenylists < ActiveRecord::Migration[8.1]
  def change
    add_column :jwt_denylists, :exp, :datetime
  end
end
