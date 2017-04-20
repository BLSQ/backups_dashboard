class AddFrequencyToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :frequency, :string
  end
end
