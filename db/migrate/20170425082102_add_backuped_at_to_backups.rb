class AddBackupedAtToBackups < ActiveRecord::Migration[5.0]
  def change
    add_column :backups, :backuped_at, :datetime
  end
end
