class AddPasswordsToTrials < ActiveRecord::Migration
  def change
    add_column :trials, :instancepw, :string
    add_column :trials, :trialpw, :string
  end
end
