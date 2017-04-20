class ChangeInternalIdTypeInBackups < ActiveRecord::Migration[5.0]
  def change
    change_column :backups, :internal_id, :string
  end

  def down 
    change_column :backups, :internal_id, :integer
  end
end
