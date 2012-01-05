# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create(:username => 'dummy')
User.create(:username => 'raravena')

Trial.create(:customername => 'Robert Sosa', :customeremail => 'robert.sosa@snaplogic.com',
            :instanceid => '32423121', :imageid => '3123412', :imageflavor => 1,
            :publicipaddr => '50.56.245.1', :cloudaccount => 'snaplogic',
            :instancepw => 'robert-sosa-snaplogic-comkdsfak', :trialpw => 'jds3334',  :status => 'Provisioning',
            :instancename => 'robert-sosa-snaplogic-com')

Trial.create(:customername => 'Mark Johnson', :customeremail => 'mj@snaplogic.com',
            :instanceid => '32423122', :imageid => '3123412', :imageflavor => 1,
            :publicipaddr => '50.56.245.2', :cloudaccount => 'snaplogic',
            :instancepw => 'mark-johnson-snaplogic-comkdsfak', :trialpw => 'jds3334',  :status => 'Provisioning',
            :instancename => 'mark-johnson-snaplogic-com')

Trial.create(:customername => 'Rose Dawson', :customeremail => 'rosedawson@snaplogic.com',
            :instanceid => '32423123', :imageid => '3123412', :imageflavor => 1,
            :publicipaddr => '50.56.245.3', :cloudaccount => 'snaplogic',
            :instancepw => 'rose-dawsson-snaplogic-comkdsfak', :trialpw => 'jds3334',  :status => 'Provisioning',
            :instancename => 'rose-dawson-snaplogic-com')

Trial.create(:customername => 'Lady Gaga', :customeremail => 'gagafamous@snaplogic.com',
            :instanceid => '32423124', :imageid => '3123412', :imageflavor => 1,
            :publicipaddr => '50.56.245.4', :cloudaccount => 'snaplogic',
            :instancepw => 'lady-gaga-snaplogic-comkdsfak', :trialpw => 'jds3334',  :status => 'Provisioning',
            :instancename => 'lady-gaga-snaplogic-com')

CloudAccount.create(:provider => 'Rackspace', :username => 'snaplogicvpn',
                    :apikey => 'dcc4d6018fd0da66685948424634e59b')

CloudAccount.create(:provider => 'AWS', :username => 'aws@snaplogic.com',
                    :privatekey => 'jdkad238kwhddkjadajdakd',
                    :certificate => 'wqgfqwfwqradafad')
