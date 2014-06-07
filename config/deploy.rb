# -*- encoding : utf-8 -*-
require 'capistrano-rbenv'
load 'deploy/assets'
ssh_options[:port] = 22
set :rake, "bundle exec rake"

set :copy_local_tar, "/usr/bin/gnutar" if RUBY_PLATFORM.match(/darwin/)
set :application, "weixin"
set :repository, "."
set :scm, :none
set :deploy_via, :copy

server = 'siwei.me'
password = ''
puts "== password for #{server} is: #{password}"

role :web, server
role :app, server
role :db,  server, :primary => true
role :db,  server

set :deploy_to, "/opt/app/siwei/shake_shake"
default_run_options[:pty] = true

# change to your username
set :user, "root"

namespace :deploy do
  task :start do
    #if server == SERVER_TEST_103
    #  run "cd #{release_path} && bundle exec thin start -C config/thin.yml"
    #else
    #  run "/opt/nginx/sbin/nginx"
    #end
  end
  task :stop do
    #if server == SERVER_TEST_103
    #  run "cd #{release_path} && bundle exec thin stop -C config/thin.yml"
    #else
    #  run "/opt/nginx/sbin/nginx -s stop"
    #end
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    db_migrate
    stop
    sleep 2
    start
  end
  task :db_migrate do
    run "cd #{release_path} && bundle install"
    run "cd #{release_path} && bundle exec rake db:migrate RAILS_ENV=production"
  end

  namespace :assets do
    task :precompile do
  #    puts "======= should run precompile"
  #    command = "cd #{release_path} && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile "
  #    puts "== please run == \n #{command} \n == manually after deploy is done"
      #run "bundle install"
      #run "cd #{release_path} && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile "
    end
  end
end


desc "Copy database.yml to release_path"
task :cp_database_yml do
  puts "=== executing my customized command: "
  run "cp -r #{shared_path}/config/* #{release_path}/config/"
  puts "=== done (executing my customized command)"
end

before "deploy:assets:precompile", :cp_database_yml
#after "deploy", "deploy:restart"
