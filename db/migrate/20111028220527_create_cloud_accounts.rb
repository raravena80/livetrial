class CreateCloudAccounts < ActiveRecord::Migration
  def change
    create_table :cloud_accounts do |t|
      t.string :provider
      t.string :username
      t.string :apikey
      t.string :privatekey
      t.string :certificate

      t.timestamps
    end
  end
end
