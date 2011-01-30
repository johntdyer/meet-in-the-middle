class AddUserNameToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :user_name, :string
  end

  def self.down
    remove_column :trips, :user_name
  end
end
