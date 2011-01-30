class AddParticipantsToTrips < ActiveRecord::Migration
  def self.up
    add_column :trips, :participants, :integer
  end

  def self.down
    remove_column :trips, :participants
  end
end
