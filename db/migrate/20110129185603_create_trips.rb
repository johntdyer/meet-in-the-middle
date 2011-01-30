class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.string :user_id
      t.datetime :orig_eta
      t.integer :participant

      t.timestamps
    end
  end

  def self.down
    drop_table :trips
  end
end
