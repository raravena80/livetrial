class ApplicationController < ActionController::Base
  protect_from_forgery
  #force_ssl
  private

  helper_method :current_user, :user_signed_in?, :user_signed_out?
  helper_method :session_expiry, :update_activity_time

  #before_filter :require_login

  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      #redirect_to :action => 'new', :controller => 'sessions'
      redirect_to new_session_url # halts request cycle
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
    @current_user
  end

  def user_signed_in?
    !!current_user
  end

  def user_signed_out?
    !user_signed_in?
  end

  # Helper method to check if a session has expired
  def session_expiry
    @time_left = (session[:expires_at] - Time.now).to_i
    unless @time_left > 0
      reset_session
      flash[:error] = "Your session has expired. Login again"
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end

  def update_activity_time
    session[:expires_at] = 20.minutes.from_now
  end

  def ldapauth( username, password )
    username = current_user[/\A\w+/].downcase
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
         :port => 389
    if ldap.bind
      puts "Yeah"
      # Yay, the login credentials were valid!
      # Get the user's full name and return it
      #ldap.search(
      #  base:         "OU=Users,OU=Accounts,DC=mycompany,DC=com",
      #  filter:       Net::LDAP::Filter.eq( "mail", email ),
      #  attributes:   %w[ displayName ],
      #  return_result:true
      #).first.displayName.first
    end
  end

  def store_location
    session[:return_to] = request.request_uri if request.get? and controller_name != "sessions"
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
  end

end
