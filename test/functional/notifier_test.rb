require 'test_helper'

# This class is for testing purposes only
class TrialTest

   attr_accessor :customername
   attr_accessor :customeremail
   attr_accessor :instancename

   def initialize
     @customername = ""
     @customeremail = ""
     @instancename = ""
   end
end


class NotifierTest < ActionMailer::TestCase

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  # replace this with your real tests
  def test_welcome
    @trial = TrialTest.new
    @trial.customername = "Ricardo Aravena"
    @trial.customeremail = "raravena@snaplogic.com"
    @trial.instancename = "raravena-snaplogic-com.dyn.snaplogic.com"
    num_deliveries = ActionMailer::Base.deliveries.size
    Notifier.welcome(@trial).deliver
    assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size
  end
end


