class AddContactToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :contact, :integer
  end

  def self.down
    remove_column :trips, :contact
  end
end
