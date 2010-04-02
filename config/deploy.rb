set :application, "Brita"
set :repository,  "git@github.com:kristjan/brita.git"

set :scm, :git
set :deploy_to, "/var/www/brita"

role :web, "brita.kripet.us"                   # Your HTTP server, Apache/etc
role :app, "brita.kripet.us"                   # This may be the same as your `Web` server
role :db,  "brita.kripet.us", :primary => true # This is where Rails migrations will run
role :db,  "brita.kripet.us"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
