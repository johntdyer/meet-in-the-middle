class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :first
      t.string :last
      t.integer :trip_id
      t.string :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
