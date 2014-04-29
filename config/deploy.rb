require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :rails_env,    'production'

set :domain,       '37.139.16.141'
set :deploy_to,    "/home/deployer/apps/loud_landing/#{rails_env}"
set :app_path,     "#{deploy_to}/#{current_path}"
set :repository,   "git@github.com:rubytribe/loud_landing.git"
set :branch,       "develop"


set :shared_paths, ['config/database.yml', 'log', 'tmp', 'public/uploads']
set :term_mode, :system

set :user, 'deployer'

task :environment do
  invoke :'rbenv:load'
end


task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

namespace :log do
  task :production => :environment do
    queue 'echo "-----> Production log: "'
    queue "tail -f #{deploy_to}/shared/log/production.log"
  end

  task :error => :environment do
    queue 'echo "-----> Error log: "'
    queue "tail -f #{deploy_to}/shared/log/error.log"
  end

  task :unicorn => :environment do
    queue 'echo "-----> Unicorn stdeer log: "'
    queue "tail -f #{deploy_to}/shared/log/unicorn.stderr.log"
  end

  task :access => :environment do
    queue 'echo "-----> Access log: "'
    queue "tail -f #{deploy_to}/shared/log/access.log"
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'unicorn:restart'
      queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end

namespace :unicorn do
  set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"

  desc "Start unicorn"
  task start: :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! %{
      cd #{app_path}
      bundle exec unicorn -c #{app_path}/config/unicorn.rb -E #{rails_env} -D
    }
  end

  desc "Stop unicorn"
  task :stop do
    queue 'echo "-----> Stop Unicorn"'
    queue! %{
      test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    }
  end

  desc "Graceful reload unicorn"
  task :reload do
    queue 'echo "-----> Reload Unicorn"'
    queue! %{
      test -s "#{unicorn_pid}" && kill -s USR2 `cat "#{unicorn_pid}"` && echo "Reload Ok" && exit 0
      echo >&2 "Not running"
    }
  end

  desc "Restart unicorn using 'upgrade'"
  task restart: :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end
