class AddStatusToTrials < ActiveRecord::Migration
  def change
    add_column :trials, :status, :string
    Trial.all.each { |f| f.update_attributes!(:status => 'Not provisioned') }
  end

  def down
    remove_column :trials, :status
  end

end
