# config valid only for current version of Capistrano
lock "3.8.2"

set :application, "fpa"
set :repo_url, "git@github.com:fierropa/fpa-ruby.git"
set :passenger_restart_with_touch, true
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads, public/images"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5



desc "Check that we can access everything"
task :check_write_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is not writable on #{host}"
    end
  end
end


#
# Helper Methods
#

def create_tmp_file(contents)
  system 'mkdir tmp'
  file = File.new("tmp/#{domain}", "w")
  file << contents
  file.close
end

# 
# Capistrano Recipe
# 
namespace :deploy do
  
  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  # lib/capistrano/tasks/agent_forwarding.rake
  desc "Check if agent forwarding is working"
  task :forwarding do
    on roles(:all) do |h|
      if test("env | grep SSH_AUTH_SOCK")
        info "Agent forwarding is up to #{h}"
      else
        error "Agent forwarding is NOT up to #{h}"
      end
    end
  end
  
  desc "Syncs the database.yml file from the local machine to the remote machine"
  task :sync_yaml do
    puts "\n\n=== Syncing database yaml to the production server! ===\n\n"
    unless File.exist?("config/database.yml")
      puts "There is no config/database.yml.\n "
      exit
    end
    unless File.exist?("config/secrets.yml")
      puts "There is no config/secrets.yml.\n "
      exit
    end
    system "rsync -vr --exclude='.DS_Store' config/database.yml deploy@#{fetch(:application)}:#{shared_path}/config/"
    system "rsync -vr --exclude='.DS_Store' config/secrets.yml deploy@#{fetch(:application)}:#{shared_path}/config/"
  end

#   # Tasks that run after every deployment (cap deploy)

#   desc "Initializes a bunch of tasks in order after the last deployment process."
#   task :restart do
#     puts "\n\n=== Running Custom Processes! ===\n\n"
#     create_production_log
#     setup_symlinks
#     application_specific_tasks
#     set_permissions
#     system 'cap deploy:passenger:restart'
#   end
#
#   # Deployment Tasks
#
#   desc "Executes the initial procedures for deploying a Ruby on Rails Application."
#   task :initial do
#     system "cap deploy:setup"
#     system "cap deploy"
#     system "cap deploy:gems:install"
#     system "cap deploy:db:create"
#     system "cap deploy:db:migrate"
#     system "cap deploy:passenger:restart"
#   end
#
#   namespace :destroy_all do
#
#     desc "Destroys Git Repository, Rails Environment and Apache2 Configuration."
#     task :apache do
#       system "cap deploy:repository:destroy"
#       run "rm -rf #{deploy_to}"
#       system "cap deploy:apache:destroy"
#     end
#
#     desc "Destroys Git Repository, Rails Environment and Nginx Configuration."
#     task :nginx do
#       system "cap deploy:repository:destroy"
#       run "rm -rf #{deploy_to}"
#       system "cap deploy:nginx:destroy"
#     end
#
#   end
#
#   namespace :passenger do
#
#     desc "Restarts Passenger"
#     task :restart do
#       puts "\n\n=== Restarting Passenger! ===\n\n"
#       on roles(:app), in: :sequence, wait: 5 do
#         # Your restart mechanism here, for example:
#         execute :touch, release_path.join('tmp/restart.txt')
#       end
#     end
#
#   end
#
#   desc "Sets permissions for Rails Application"
#   task :set_permissions do
#     puts "\n\n=== Setting Permissions! ===\n\n"
#     run "chown -R www-data:www-data #{deploy_to}"
#   end
#
#   desc "Creates the production log if it does not exist"
#   task :create_production_log do
#     unless File.exist?(File.join(shared_path, 'log', 'production.log'))
#       puts "\n\n=== Creating Production Log! ===\n\n"
#       run "touch #{File.join(shared_path, 'log', 'production.log')}"
#     end
#   end
#
#   desc "Creates symbolic links from shared folder"
#   task :setup_symlinks do
#     puts "\n\n=== Setting up Symbolic Links! ===\n\n"
#     symlink_configuration.each do |config|
#       run "ln -nfs #{File.join(shared_path, config[0])} #{File.join(release_path, config[1])}"
#     end
#   end
#
#   # Manual Tasks
#
#   namespace :db do
#
#     desc "Syncs the database.yml file from the local machine to the remote machine"
#     task :sync_yaml do
#       puts "\n\n=== Syncing database yaml to the production server! ===\n\n"
#       unless File.exist?("config/database.yml")
#         puts "There is no config/database.yml.\n "
#         exit
#       end
#       system "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{application}:#{shared_path}/config/"
#     end
#
#     desc "Create Production Database"
#     task :create do
#       puts "\n\n=== Creating the Production Database! ===\n\n"
#       run "cd #{current_path}; rake db:create RAILS_ENV=production"
#       system "cap deploy:set_permissions"
#     end
#
#     desc "Migrate Production Database"
#     task :migrate do
#       puts "\n\n=== Migrating the Production Database! ===\n\n"
#       run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
#       system "cap deploy:set_permissions"
#     end
#
#     desc "Resets the Production Database"
#     task :migrate_reset do
#       puts "\n\n=== Resetting the Production Database! ===\n\n"
#       run "cd #{current_path}; rake db:migrate:reset RAILS_ENV=production"
#     end
#
#     desc "Destroys Production Database"
#     task :drop do
#       puts "\n\n=== Destroying the Production Database! ===\n\n"
#       run "cd #{current_path}; rake db:drop RAILS_ENV=production"
#       system "cap deploy:set_permissions"
#     end
#
#     desc "Moves the SQLite3 Production Database to the shared path"
#     task :move_to_shared do
#       puts "\n\n=== Moving the SQLite3 Production Database to the shared path! ===\n\n"
#       run "mv #{current_path}/db/production.sqlite3 #{shared_path}/db/production.sqlite3"
#       system "cap deploy:setup_symlinks"
#       system "cap deploy:set_permissions"
#     end
#
#     desc "Populates the Production Database"
#     task :seed do
#       puts "\n\n=== Populating the Production Database! ===\n\n"
#       run "cd #{current_path}; rake db:seed RAILS_ENV=production"
#     end
#
#   end
#
#   namespace :gems do
#
#     desc "Installs any 'not-yet-installed' gems on the production server or a single gem when the gem= is specified."
#     task :install do
#       if ENV['gem']
#         puts "\n\n=== Installing #{ENV['gem']}! ===\n\n"
#         run "gem install #{ENV['gem']}"
#       else
#         puts "\n\n=== Installing required RubyGems! ===\n\n"
#         run "cd #{current_path}; rake gems:install RAILS_ENV=production"
#       end
#     end
#
#   end
#
#   namespace :repository do
#
#     desc "Creates the remote Git repository."
#     task :create do
#       puts "\n\n=== Creating remote Git repository! ===\n\n"
#       run "mkdir -p #{repository_path}"
#       run "cd #{repository_path} && git --bare init"
#       system "git remote rm origin"
#       system "git remote add origin #{repository[:repository]}"
#       p "#{repository[:repository]} was added to your git repository as origin/master."
#     end
#
#     desc "Creates the remote Git repository."
#     task :destroy do
#       puts "\n\n=== destroying remote Git repository! ===\n\n"
#       run "rm -rf #{repository_path}"
#       system "git remote rm origin"
#       p "#{repository[:repository]} (origin/master) was removed from your git repository."
#     end
#
#     desc "Resets the remote Git repository."
#     task :reset do
#       puts "\n\n=== Resetting remove Git repository! ===\n\n"
#       system "cap deploy:repository:destroy"
#       system "cap deploy:repository:create"
#     end
#
#     desc "Reinitializes Origin/Master."
#     task :reinitialize do
#       system "git remote rm origin"
#       system "git remote add origin #{repository[:repository]}"
#       p "#{repository[:repository]} (origin/master) was added to your git repository."
#     end
#
#   end
#
#   namespace :environment do
#
#     desc "Creates the production environment"
#     task :create do
#       system "cap deploy:setup"
#     end
#
#     desc "Destroys the production environment"
#     task :destroy do
#       run "rm -rf #{deploy_to}"
#     end
#
#     desc "Resets the production environment"
#     task :reset do
#       run "rm -rf #{deploy_to}"
#       system "cap deploy:setup"
#     end
#
#   end
#
#
#   namespace :delayed_job do
#
#     desc "Starts the Delayed Job Daemon(s)."
#     task :start do
#       puts "\n\n=== Starting #{(ENV['n'] + ' ') if ENV['n']}Delayed Job Daemon(s)! ===\n\n"
#       run "RAILS_ENV=production #{current_path}/script/delayed_job #{"-n #{ENV['n']} " if ENV['n']}start"
#     end
#
#     desc "Stops the Delayed Job Daemon(s)."
#     task :stop do
#       puts "\n\n=== Stopping Delayed Job Daemon(s)! ===\n\n"
#       run "RAILS_ENV=production #{current_path}/script/delayed_job stop"
#     end
#
#   end
#
#   namespace :nginx do
#
#     desc "Adds NginX configuration and enables it."
#     task :create do
#       puts "\n\n=== Adding NginX Virtual Host for #{domain}! ===\n\n"
#       config = <<-CONFIG
#       server {
#         listen 80;
#         server_name #{unless subdomain then "www.#{domain} #{domain}" else domain end};
#         root #{File.join(deploy_to, 'current', 'public')};
#         passenger_enabled on;
#       }
#       CONFIG
#
#       create_tmp_file(config)
#       run "mkdir -p /opt/nginx/conf/sites-enabled"
#       system "rsync -vr tmp/#{domain} #{user}@#{application}:/opt/nginx/conf/sites-enabled/#{domain}"
#       File.delete("tmp/#{domain}")
#       system 'cap deploy:nginx:restart'
#     end
#
#     desc "Restarts NginX."
#     task :restart do
#       Net::SSH.start(application, user) {|ssh| ssh.exec "/etc/init.d/nginx stop"}
#       Net::SSH.start(application, user) {|ssh| ssh.exec "/etc/init.d/nginx start"}
#     end
#
#     desc "Removes NginX configuration and disables it."
#     task :destroy do
#       puts "\n\n=== Removing NginX Virtual Host for #{domain}! ===\n\n"
#       begin
#         run("rm /opt/nginx/conf/sites-enabled/#{domain}")
#       ensure
#         system 'cap deploy:nginx:restart'
#       end
#     end
#
#   end
#
#   desc "Run a command on the remote server. Specify command='my_command'."
#   task :run_command do
#     run "cd #{current_path}; #{ENV['command']}"
#   end
#
#   # Tasks that run after the (cap deploy:setup)
#
#   desc "Sets up the shared path"
#   task :setup_shared_path do
#     puts "\n\n=== Setting up the shared path! ===\n\n"
#     directory_configuration.each do |directory|
#       run "mkdir -p #{shared_path}/#{directory}"
#     end
#     system "cap deploy:db:sync_yaml"
#   end
#
#
#   # after :setup, :setup_shared_path
#
end
 
# Callbacks
