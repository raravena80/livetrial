class AddPublicIpToTrials < ActiveRecord::Migration
  def self.up
    add_column :trials, :publicipaddr, :string
  end

  def self.down
    remove_column :trials, :publicipaddr
  end
end
