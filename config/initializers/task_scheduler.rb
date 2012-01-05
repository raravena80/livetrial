

def execute_scheduler

  scheduler = Rufus::Scheduler.start_new
  
  scheduler.every("1m") do
     @trials = Trial.all
     @trials.each do |trial|
       # Check if the trial passed the threshold where it needs to be deleted
       if trial.threshold?
         #trial.destroy
         next
       end

       # In case the trial just expire send a warning to trial requester
       if trial.expired?
         puts "Trial for #{trial.customername} expired"
         # Send email to the customer specifying that their livetrial is completed
         #Notifier.warning(trial).deliver
       end
       #puts trial.status
       Rails.logger.info trial.status

       if (trial.status == "Provisioning" && trial.check_provision_return_code(trial.instancename, "admin", trial.trialpw) == "404") then
          trial.status = "Provisioned"
          trial.save
          # Send email to the customer specifying that their livetrial is completed
          begin
            Notifier.welcome(trial).deliver
          rescue Errno::ECONNREFUSED => e
            Rails.logger.info "Caught exception when trying to send email" + e
            # Catch the case where there's no sendmail in the box
          end
       end

     end
  end # End of scheduler

end

# Create the main logger and set some useful variables.
main_logger = Logger.new(Rails.root.to_s + "/log/scheduler.log")
pid_file = (Rails.root.to_s + "/log/scheduler.pid").to_s
File.delete(pid_file) if FileTest.exists?(pid_file)

if defined?(PhusionPassenger) then
    # Passenger is starting a new process
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
        # If we are forked and there's no pid file (that is no lock)
        if forked && !FileTest.exists?(pid_file) then
            main_logger.debug "SCHEDULER START ON PROCESS #{$$}"
            # Write the current PID on the file
            File.open(pid_file, "w") {
                |f| f.write($$)
            }

            # Execute the scheduler
            execute_scheduler
        end
    end
    # Passenger is shutting down a process.
    PhusionPassenger.on_event(:stopping_worker_process) do
        # If a pid file exists and the process which
        # is being shutted down is the same which holds the lock
        # (in other words, the process which is executing the scheduler)
        # we remove the lock.
        if FileTest.exists?(pid_file) then
            if File.open(pid_file, "r") {|f| pid = f.read.to_i} == $$ then
                main_logger.debug "SCHEDULER STOP ON PROCESS #{$$}"
                File.delete(pid_file)
                File.close
            end
        end
    end
else # Only execute one scheduler
    execute_scheduler
end


