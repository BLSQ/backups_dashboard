class AddAutobusTokenToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :autobus_token, :string
  end
end
