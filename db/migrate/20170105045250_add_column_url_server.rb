class AddColumnUrlServer < ActiveRecord::Migration[5.0]
  def change
    add_column :encode_jobs, :download, :boolean
    add_column :encode_jobs, :server_id, :integer
    add_column :encode_jobs, :extras, :string
  end
end
