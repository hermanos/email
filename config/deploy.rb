require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '54.217.242.116' # 'mooseumapp.com'
# Optional settings:
set :user, 'ubuntu'    # Username in the server to SSH to.
set :identity_file, '~/.ssh/bootcamp.pem'     # Optional

set :deploy_to, '/var/www/echoesapp.com'
set :app_path, "#{deploy_to}/#{current_path}"
set :pid_file, "#{deploy_to}/shared/tmp/pids/#{rails_env}.pid"
set :repository, 'git@github.com:hermanos/email.git'
set :branch, 'master'
set :term_mode, :system

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'tmp']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end





#                                                                       Unicorn
# ==============================================================================
namespace :unicorn do
  set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"
  set :start_unicorn, %{
    cd #{app_path}
    bundle exec unicorn -c #{app_path}/config/unicorn/#{rails_env}.rb -E #{rails_env} -D
  }

#                                                                    Start task
# ------------------------------------------------------------------------------
  desc "Start unicorn"
  task :start => :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! start_unicorn
  end

#                                                                     Stop task
# ------------------------------------------------------------------------------
  desc "Stop unicorn"
  task :stop do
    queue 'echo "-----> Stop Unicorn"'
    queue! %{
      test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    }
  end

#                                                                  Restart task
# ------------------------------------------------------------------------------
  desc "Restart unicorn using 'upgrade'"
  task :restart => :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end
