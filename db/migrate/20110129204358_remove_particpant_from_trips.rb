class RemoveParticpantFromTrips < ActiveRecord::Migration
  def self.up 
    remove_column :trips, :participant
    
  end

  def self.down
    add_column :trips, :participant
    
  end
end
