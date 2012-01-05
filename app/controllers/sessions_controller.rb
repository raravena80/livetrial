class SessionsController < ApplicationController

  #before_filter :user_signed_in?, :only => [:delete]
  # Function to do ldap authentication on the Snaplogic 
  # LDAP server
  def ldapauth( username, password )
    username = username.downcase
    #username = username[/\A\w+/].downcase
    #username << "@snaplogic.com"
    #email = email[/\A\w+/].downcase
    # Throw out the domain, if it was there
    #email << "@snaplogic.com"
    # I only check people in my company
    # Thankfully this is a standard name
    fullusername = "uid=" + username + ",ou=Users,dc=snaplogic,dc=com"
    ldap = Net::LDAP.new :host => 'adm1.snaplogic.com',
         :auth => {
               :method => :simple,
               :username => fullusername,
               :password => password },
         :port => 636,
         :encryption => :simple_tls
    if ldap.bind
      #puts "Yeah"
      # Yay, the login credentials were valid!
      # Get the user's full name and return it
      #ldap.search(
      #  base:         "OU=Users,OU=Accounts,DC=mycompany,DC=com",
      #  filter:       Net::LDAP::Filter.eq( "mail", email ),
      #  attributes:   %w[ displayName ],
      #  return_result:true
      #).first.displayName.first
      true
    else
      false
    end
  end

  def new  
  end  
 
  def create  
    user = User.find_by_username(params[:username])  
    #if user && user.authenticate(params[:password])
    respond_to do |format|
      if user && ldapauth(params[:username], params[:password])  
        session[:user_id] = user.id
        update_activity_time
        format.html { redirect_to trials_url, :notice => "Logged in!" }
        #format.html { redirect_to :back, :notice => "Logged in!" }
        format.xml  { head :ok }
        format.json  { head :ok }
      else  
        flash.now.alert = "Invalid username or password"  
        format.html { render "new" }
        format.xml  { render :xml => user.errors, :status => :unprocessable_entity }
        format.json  { render :json => user.errors, :status => :unprocessable_entity }
      end
    end  
  end   
  
  def destroy  
    session[:user_id] = nil  
    respond_to do |format|
      format.html { redirect_to trials_url, :notice => "Logged out!" }
      format.xml { head :ok }
      format.json { head :ok }
    end
  end

  def delete
    session.delete(:user_id)
  end

end
