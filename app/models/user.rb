class User < ActiveRecord::Base
  #attr_accessible :email, :username, :password, :password_confirmation
  attr_accessible :username
  #has_secure_password
  #validates_presence_of :password, :on => :create
  validates_presence_of :username, :on => :create
end
