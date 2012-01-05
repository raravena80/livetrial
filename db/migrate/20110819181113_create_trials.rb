class CreateTrials < ActiveRecord::Migration
  def self.up
    create_table :trials do |t|
      t.string :customername
      t.string :customeremail
      t.string :instancename
      t.integer :instanceid
      t.integer :imageid
      t.integer :imageflavor

      t.timestamps
    end
  end

  def self.down
    drop_table :trials
  end
end
