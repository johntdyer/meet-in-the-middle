class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.datetime :original_eta
      t.string :phone_guid
      t.datetime :latest_eta

      t.timestamps
    end
  end

  def self.down
    drop_table :trips
  end
end
