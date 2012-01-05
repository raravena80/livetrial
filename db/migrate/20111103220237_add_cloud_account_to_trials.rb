class AddCloudAccountToTrials < ActiveRecord::Migration
  def change
    add_column :trials, :cloudaccount, :string
    Trial.all.each { |f| f.update_attributes!(:cloudaccount => 'snaplogicvpn') }
  end

  def down
    remove_column :trials, :cloudaccount
  end

end
