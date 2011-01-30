class AddDestinationToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :destination, :string
  end

  def self.down
    remove_column :trips, :destination
  end
end
