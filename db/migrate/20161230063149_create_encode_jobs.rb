class CreateEncodeJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :encode_jobs do |t|
      t.text :params
      t.string :title
      t.string :filename
      t.integer :user_id
      t.integer :phase
      t.string :outname

      t.timestamps
    end
  end
end
