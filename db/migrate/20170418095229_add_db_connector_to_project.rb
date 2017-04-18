class AddDbConnectorToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :db_connector, :integer
  end
end
