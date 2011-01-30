class RenameStartingLatToStartLat < ActiveRecord::Migration
  def self.up                                          
        rename_column :participants, :starting_lat,:start_lat
  end

  def self.down   
        rename_column :participants, :start_lat,:starting_lat
  end
end
