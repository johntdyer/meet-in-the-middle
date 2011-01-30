class RemoveContactIdFromTrips < ActiveRecord::Migration
  def self.up 
    remove_column :trips, :contact_id
  end

  def self.down
    add_column :trips, :contact_id
  end
end
