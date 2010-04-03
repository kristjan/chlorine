set :application, "Brita"
set :repository,  "git@github.com:kristjan/brita.git"

set :scm, :git
set :deploy_to, "/var/www/brita"
set :use_sudo, false

role :web, "brita.kripet.us"                   # Your HTTP server, Apache/etc
role :app, "brita.kripet.us"                   # This may be the same as your `Web` server
role :db,  "brita.kripet.us", :primary => true # This is where Rails migrations will run
role :db,  "brita.kripet.us"

default_environment["PATH"] = "/var/lib/gems/1.8/bin:/usr/local/bin:/usr/bin:/bin"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # taken from Advanced Rails Recipes
  task :copy_database_configuration do
    production_db_config = "#{deploy_to}/shared/production.database.yml"
    run "cp #{production_db_config} #{release_path}/config/database.yml"
  end
  after "deploy:update_code", "deploy:copy_database_configuration"
end