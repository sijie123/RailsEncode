class CreateServers < ActiveRecord::Migration[5.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :ip
      t.integer :threads

      t.timestamps
    end
  end
end
