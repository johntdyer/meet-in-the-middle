class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :first
      t.string :last
      t.string :phone
      t.float :starting_lat
      t.float :starting_long

      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
