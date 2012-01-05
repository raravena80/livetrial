class CloudAccountsController < ApplicationController

  before_filter :require_login, :session_expiry
  # GET /cloud_accounts
  # GET /cloud_accounts.json
  def index
    @cloud_accounts = CloudAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cloud_accounts }
    end
  end

  # GET /cloud_accounts/1
  # GET /cloud_accounts/1.json
  def show
    @cloud_account = CloudAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cloud_account }
    end
  end

  # GET /cloud_accounts/new
  # GET /cloud_accounts/new.json
  def new
    @cloud_account = CloudAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cloud_account }
    end
  end

  # GET /cloud_accounts/1/edit
  def edit
    @cloud_account = CloudAccount.find(params[:id])
  end

  # POST /cloud_accounts
  # POST /cloud_accounts.json
  def create
    @cloud_account = CloudAccount.new(params[:cloud_account])

    respond_to do |format|
      if @cloud_account.save
        format.html { redirect_to @cloud_account, :notice => 'Cloud account was successfully created.' }
        format.json { render :json => @cloud_account, :status => :created, :location => @cloud_account }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cloud_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cloud_accounts/1
  # PUT /cloud_accounts/1.json
  def update
    @cloud_account = CloudAccount.find(params[:id])

    respond_to do |format|
      if @cloud_account.update_attributes(params[:cloud_account])
        format.html { redirect_to @cloud_account, :notice => 'Cloud account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cloud_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_accounts/1
  # DELETE /cloud_accounts/1.json
  def destroy
    @cloud_account = CloudAccount.find(params[:id])
    @cloud_account.destroy

    respond_to do |format|
      format.html { redirect_to cloud_accounts_url }
      format.json { head :ok }
    end
  end
end
