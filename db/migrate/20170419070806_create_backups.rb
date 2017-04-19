class CreateBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :backups do |t|
      t.string :status
      t.integer :internal_id
      t.string :size
      t.string :frequency
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
