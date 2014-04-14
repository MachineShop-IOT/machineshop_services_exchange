## These setting were originally set up to work with Amazon EC2 and NGINX. 
## Specifications will need to be adjusted, based on your set up.

require 'bundler/capistrano'
require 'rvm/capistrano'

# environment
set :application, 'machineshop_portal'
set :keep_releases, 3
set :rvm_path, 'YOUR_PATH_TO/.rvm/'
set :rvm_bin_path, 'YOUR_PATH_TO/.rvm/bin'
set :rvm_ruby_string, 'default'
set :bundle_without, [:development, :test]


# authentication
set :user, "YOUR_USER"
set :use_sudo, false
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/YOUR_KEY.pem"]

# scm
set :scm, :git
set :repository, 'git@github.com:YOUR_NAME/machineshop_services_exchange.git'
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :deploy_via, :remote_cache # reuse a single git clone

desc 'Deploy to production (usage: cap production deploy)'
task :production do
  set :rails_env, 'production'
  set :branch, 'master'
  set :deploy_to, "/home/YOUR_USER/#{rails_env}.#{application}"
  
  server 'YOUR_SERVER_IP', :web, :app, :db, primary: true
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
   task :start do ; end
   task :stop do ; end

   task :restart, :roles => :app do
     run 'sudo service nginx stop'
     run 'sudo service nginx start'
   end
end

after 'deploy:restart', 'deploy:cleanup'