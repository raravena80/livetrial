class Notifier < ActionMailer::Base
  default :from => "\"Team SnapLogic\" <live-trial-requests@snaplogic.com>"

  def welcome(trial)
    @trial = trial
    @url = "http://#{@trial.instancename}/designer"
    # Convert IP address to uses dashes instead of dots
    # For example 10.10.10.10 would now be 10-10-10-10
    @dashipaddr = @trial.publicipaddr.gsub(".","-")
    # Concatenate the dashed IP to a full hostname
    @rackspacecloudhost = @dashipaddr + ".static.cloud-ips.com"
    #@url = "http://#{@trial.publicipaddr}/__snap__/__static__/designer/SnapClient.html"
    #@url = "http://#{@rackspacecloudhost}/__snap__/__static__/designer/SnapClient.html"
    mail(:to => trial.customeremail,
         :subject => "Welcome to SnapLogic")
  end

  def warning(trial)
    @trial = trial
    @url = "http://#{@trial.instancename}/designer"
    # Convert IP address to uses dashes instead of dots
    # For example 10.10.10.10 would now be 10-10-10-10
    @dashipaddr = @trial.publicipaddr.gsub(".","-")
    # Concatenate the dashed IP to a full hostname
    @rackspacecloudhost = @dashipaddr + ".static.cloud-ips.com"
    #@url = "http://#{@trial.publicipaddr}/__snap__/__static__/designer/SnapClient.html"
    #@url = "http://#{@rackspacecloudhost}/__snap__/__static__/designer/SnapClient.html"
    #mail(:to => trial.customeremail,
    mail(:to => "booter@snaplogic.com",
         :subject => "Your SnapLogic LiveTrial is about to Expire!")
  end

end
