class UsersController < ApplicationController
  def new  
    @user = User.new  
  end  
  
  def create  
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to trials_url, :notice => "Signed up!" } 
        format.xml  { head :ok }
        format.json  { head :ok }
      else  
        format.html { render "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end  
    end 

  end

end
