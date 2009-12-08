#------------  Deploy with Git ----------------------

set :application, "winnamoney.innku.com"
set :rails_env, "production"
set :base_path, "production"
set :use_sudo,  false

default_run_options[:pty] = true
set :repository,  "git@github.com:fedegl/winnamoney.git"
set :scm, "git"
set :scm_passphrase, "soyinnku09"
set :user, "winna"

set :deploy_to, "/home/#{user}/#{base_path}"
set :branch, "master"
set :deploy_via,  :remote_cache

role :app, application
role :web, application
role :db,  application, :primary => true

namespace :deploy do

  desc "Reiniciar el servidor rails"
  task :restart,  :roles => :app, :except =>  {:no_release => true} do
    run "touch  #{current_path}/tmp/restart.txt"
  end
  
  [:start,:stop].each do |t|
    desc "#{t}  task is no-op with mod_rails"
    task t,   :roles => :app do ; end
  end
end
