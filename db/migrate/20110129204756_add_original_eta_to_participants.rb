class AddOriginalEtaToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :original_eta, :datetime
  end

  def self.down
    remove_column :participants, :original_eta
  end
end
