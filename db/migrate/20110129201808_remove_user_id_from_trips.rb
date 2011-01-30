class RemoveUserIdFromTrips < ActiveRecord::Migration
  def self.up    
    remove_column :trips, :user_id
    
  end

  def self.down  
    add_column :trips, :user_id
    
  end               
  
end
