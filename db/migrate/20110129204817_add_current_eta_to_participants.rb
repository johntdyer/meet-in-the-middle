class AddCurrentEtaToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :current_eta, :datetime
  end

  def self.down
    remove_column :participants, :current_eta
  end
end
