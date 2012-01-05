module TrialsHelper

  #helper_method :current_email

  private
    def current_email
      @current_email ||= Project.find(session[:customeremail])
    end

end
