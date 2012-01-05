#---
# Excerpted from "Advanced Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_arr for more book information.
#---

require 'resolv'

class Trial < ActiveRecord::Base
  
  EMAIL_PATTERN = /(\S+)@(\S+)/

  validates_format_of :customeremail, :with => EMAIL_PATTERN
  validates_uniqueness_of :customeremail
  
  def validate
    unless errors[:customeremail].count >= 1
    #unless errors.on(:customeremail)
      unless valid_domain?(customeremail)
        errors.add(:customeremail, 'domain name appears to be incorrect') 
      end
    end
  end


  SERVER_TIMEOUT = 3 # seconds

  def valid_domain?(email)
    domain = email.match(EMAIL_PATTERN)[2]
    
    dns = Resolv::DNS.new

    Timeout::timeout(SERVER_TIMEOUT) do
      # Check the MX records
      mx_records = 
        dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    
      mx_records.sort_by {|mx| mx.preference}.each do |mx|
        a_records = dns.getresources(mx.exchange.to_s, 
                                     Resolv::DNS::Resource::IN::A)
        return true if a_records.any?
      end
      
      # Try a straight A record
      a_records = dns.getresources(domain, Resolv::DNS::Resource::IN::A)
      a_records.any?
    end
  rescue Timeout::Error, Errno::ECONNREFUSED
    false
  end

  # Check if the trials has expired
  def expired?
    created_at < 14.days.ago && updated_at < 14.days.ago
  end

  # Check if the trial has reached the point of deletion threshold
  def threshold?
    created_at < 200.days.ago && updated_at < 200.days.ago
  end

  # Extend the livetrial by 14 days
  def extendbyfourteendays
    updated_at = Time.now
  end

  # Extend the livetrial by 30 days
  def extendbythirthydays
    update_at = update_at + 14.days.from_now
  end

  # This function gets the trialpw from the instance
  def sftptrialpwget( host, username, password )
    require 'net/ssh'
    require 'net/http'
    require 'net/sftp'

    @trialpw = nil
    uri = URI.parse("http://#{host}")

    begin
      # Check if the server is up first for four minutes
      # Using HTTP
      Timeout::timeout(240) do
        begin
          while ( Net::HTTP.get_response(uri).code != "200" ) do
            sleep 2
          end
        rescue Errno::ECONNREFUSED
          # Connection refused means the server is coming up
          # But the SnapLogic server is not up yet
          retry
        end
      end

      Net::SFTP.start(host, username, :password => password) do |sftp|
        begin
          @data = sftp.download!("/opt/snaplogic/config/textpasswords").split('\n')
        rescue RuntimeError
          # File not found maybe a earlier version of snaplogic
          @data = nil
          @trialpw = 'thinkcloud'
        end

        @data.each do |entry|
          entry = entry.split(' ')
          if (entry.first == "admin:")
             @trialpw = entry.second
             break
          end
        end
      end

    rescue Timeout::Error
      # This means that the server didn't come up, timeout
      raise
    rescue Net::SSH::AuthenticationFailed
      # Do nothing "Authentication failed"
    rescue SocketError
      # Do nothing the hostname is bogus
    end # end of rescue
    @trialpw
  end

  def check_provision_status( host, username, password)
    require 'net/ssh'
    require 'net/http'
    require 'net/sftp'

    uri = URI.parse("http://#{host}/__snap__/__static__/protected/ground.cert")

    begin
      # Using HTTP
      Timeout::timeout(240) do
        begin
          if ( Net::HTTP.get_response(uri).code == "404" ) then
            status = "Provisioned"
          elsif ( Net::HTTP.get_response(uri).code == "200" ) then
            status = "Not provisioned"
          else
            status = "Unknown"
          end
        rescue Errno::ECONNREFUSED
          puts "Exception"
          # Connection refused means the server is coming up
          # But the SnapLogic server is not up yet
        end
      end

    rescue Timeout::Error
      # This means that the server is not up, timeout
       status = "Down"
    end # End of rescue
    status
  end

  def check_provision_return_code( host, username, password)
    require 'net/ssh'
    require 'net/http'
    require 'net/sftp'

    @uri = URI.parse("http://#{host}/__snap__/__static__/protected/ground.cert")

    @request = Net::HTTP::Get.new(@uri.request_uri)
    @request.basic_auth username, password

    begin
      @response = Net::HTTP.start(@uri.host, @uri.port) {|http|
        http.request(@request)
      }
      @response.code
    rescue SocketError => e
      puts "Exception: " + e
    rescue
      puts "General exception"
    end

  end

end

