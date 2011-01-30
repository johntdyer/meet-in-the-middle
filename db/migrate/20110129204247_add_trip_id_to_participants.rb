class AddTripIdToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :trip_id, :integer
  end

  def self.down
    remove_column :participants, :trip_id
  end
end
