class TrialsController < ApplicationController
  # Include the snaplogic rackspace library 

  before_filter :require_login, :session_expiry

  # GET /trials
  # GET /trials.xml
  def index
    #@trials = Trial.all
    if  params[:customername].nil? and params[:customeremail]
       @trials = Trial.find(:all, :conditions => ["customeremail = ?", params[:customeremail]])
    elsif params[:customername] and params[:customeremail].nil?
       @trials = Trial.find(:all, :conditions => ["customername = ?", params[:customername]])
    elsif params[:customername] and params[:customeremail]
       @trials = Trial.find(:all, :conditions => ["customername = ? AND customeremail = ?",
       params[:customername], params[:customeremail]])
    else
       @trials = Trial.paginate(:page => params[:page], :per_page => 20)
       #@trials = Trial.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trials }
      format.json  { render :json => @trials }
    end
  end

  # GET /trials/1
  # GET /trials/1.xml
  def show
    @trial = Trial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trial }
      format.json  { render :json => @trial }
    end
  end

  # GET /trials/customeremail
  # GET /trials/customeremail.xml
  def shownew
    @trial = Trial.find_by_customeremail(params[:id])

    respond_to do |format|
      format.html # show_name.html.erb
      format.xml { render :xml => @trial }
      format.json { render :json => @trial }
    end
  end


  # GET /trials/new
  # GET /trials/new.xml
  def new
    @trial = Trial.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trial }
      format.json  { render :json => @trial }
    end
  end

  # GET /trials/1/edit
  def edit
    @trial = Trial.find(params[:id])
  end

  # POST /trials.xml
  # POST /trials.json
  def create
    @trial = Trial.new(params[:trial])

    @cloud_accounts = CloudAccount.all

    # Get rid of non rackspace accounts (AWS, gogrid, etc)
    @cloud_accounts.each_with_index do |e, i|
      @cloud_accounts.delete_at(i) if (e.provider.casecmp("Rackspace") != 0)
    end
    # Pick a ramdom Rackspace Account
    current_cloud_account = @cloud_accounts[rand(@cloud_accounts.count)]

    # Assign username and apikey
    username = current_cloud_account.username
    apikey = current_cloud_account.apikey

    respond_to do |format|
      if @trial.save
        parameters = ["-u",username,"-a",apikey,
                      "-C",@trial.customername,"-E",@trial.customeremail,
                      "-i", "16631193", "-F", "3"]
        options = SnaplogicRackspace::ParseArguments.parse(parameters)
        @livetrial = SnaplogicRackspace::LiveTrialServer.new(options)
        puts options
        # Create live trial server
        @livetrial.createlive(options)
        server = @livetrial.newserver
        # Populate live trial instance parameters
        @trial.instancepw = server.adminPass
        @trial.instanceid = server.id
        @trial.instancename = server.name
        @trial.imageflavor = server.flavor.id
        @trial.imageid = server.imageId
        @trial.cloudaccount = username

        # Get the server public ip
        @trial.publicipaddr = server.addresses[:public].first

        # Save the parameters above returned by rackspace
        # This is so that we delete instances cleanly
        # in case something fails
        @trial.save

        # Sleep for a 240 seconds for livetrial to come up
        sleep(240)

        # Get the password for the snaplogic server
        @trial.trialpw = @trial.sftptrialpwget(server.name, 'root', server.adminPass)
        # If password is nil then return error
        # Server didn't come up or something wrong
        if @trial.trialpw.nil?
          format.html { render :action => "new" }
          format.xml  { render :xml => @trial.errors, :status => :unprocessable_entity }
          format.json  { render :json => @trial.errors, :status => :unprocessable_entity }
        end

        # Start the provisioning by making ReST call to jenkins
        status = "Not provisioned"
        RestClient.post('https://dummy:Snaplogic123!@50.56.216.101/job/SnapLogic%20Sidekick%20Build%20Provisioner/buildWithParameters', :SVN_ID => '-i 18328', :BRANCH => '-b 3.3.1', :CLOUDSERVER => "-c #{@trial.instancename}", :CUSTOMERNAME => "-n \"#{@trial.customername}\"") \
        {|response, request, result, &block|
          case response.code
            when 200
              status = "Provisioning"
            # response
            when 302
              status = "Provisioning"
            # response
            # else
            #   response.return!(request, result, &block)
            end
        }

        @trial.status = status

        # Wait for 10 minutes
        # sleep(500)

        # Send email to the customer specifying that their livetrial is completed
        # begin
        #   Notifier.welcome(@trial).deliver
        # rescue Errno::ECONNREFUSED => e
        #   # Catch the case where there's no sendmail in the box
        #   logger.info "Caught exception when trying to send email" + e
        # end

        # Save the parameters above returned by rackspace
        unless @trial.save
          format.html { render :action => "new" }
          format.xml  { render :xml => @trial.errors, :status => :unprocessable_entity }
          format.json  { render :json => @trial.errors, :status => :unprocessable_entity }
        end

        format.html { redirect_to(@trial, :notice => 'Trial was successfully created.') }
        format.xml  { render :xml => @trial, :status => :created, :location => @trial }
        format.json  { render :json => @trial, :status => :created, :location => @trial }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trial.errors, :status => :unprocessable_entity }
        format.json  { render :json => @trial.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trials/1
  # PUT /trials/1.xml
  # PUT /trials/1.json
  def update
    @trial = Trial.find(params[:id])

    respond_to do |format|
      if @trial.update_attributes(params[:trial])
        format.html { redirect_to(@trial, :notice => 'Trial was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trial.errors, :status => :unprocessable_entity }
        format.json  { render :json => @trial.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trials/1
  # DELETE /trials/1.xml
  # DELETE /trials/1.json
  def destroy
    @trial = Trial.find(params[:id])

    # Delete live trial instance if not nil
    unless @trial.instanceid.nil?
      # Populate username variable from trials model
      username = @trial.cloudaccount
      # Populate the apikey
      @cloud_account = CloudAccount.find_by_username(username)
      apikey = @cloud_account.apikey

      parameters = ["-u", username, "-a", apikey,
                    "-C", @trial.customername, "-E", @trial.customeremail]
      options = SnaplogicRackspace::ParseArguments.parse(parameters)
      @livetrial = SnaplogicRackspace::LiveTrialServer.new(options)
      @livetrial.deletelive(@trial.instanceid)
    end

    # Delete object  instance
    @trial.destroy

    respond_to do |format|
      format.html { redirect_to(trials_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
