class RenameStartingLongToStartLong < ActiveRecord::Migration
  def self.up
    rename_column :participants, :starting_long, :start_long
  end

  def self.down 
    rename_column :participants, :start_long,:starting_long
  end
end
