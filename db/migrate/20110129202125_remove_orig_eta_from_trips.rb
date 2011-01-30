class RemoveOrigEtaFromTrips < ActiveRecord::Migration
  def self.up   
    remove_column :trips, :orig_eta
    
  end

  def self.down
    add_column :trips, :orig_eta
    
  end
end
