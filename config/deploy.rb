set :application, "livecontroller"
set :repository,  "git+ssh://git.snaplogic.com/development/code/snapweb/livetrial"
set :domain, 'ltcontroller.snaplogic.com'

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "root"
#set :scm_passphrase, "Snaplogic123!"
set :deploy_to, "/var/www/html/livetrial"

#ssh_options[:forward_agent] = true
# Set the branch
set :branch, "master"

# In most cases you want to use this option, otherwise each deploy will do a full 
# repository clone every time
set :deploy_via, :remote_cache
# If you’re using git submodules you must tell cap to fetch them.
set :git_enable_submodules, 1

role :web, domain       # Your HTTP server, Apache/etc
role :app, domain       # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
set :use_sudo, false

# Make old warnings go away
# set :normalize_asset_timestamps, false

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Gems installation for dependencies
after "deploy:update_code", "gems:install"

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    #run "cd #{current_release} && rake gems:install"
    run "cd #{current_release} && bundle install"
  end
end
