class AddContactIdToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :contact_id, :integer
  end

  def self.down
    remove_column :trips, :contact_id
  end
end
