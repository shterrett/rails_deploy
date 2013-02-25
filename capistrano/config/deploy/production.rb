set :user,        "webuser"

# target
server            "web_server_name_or_ip", :app, :web, :db, primary: true
server            "db_server_name_or_ip", :db, no_release: true
set :rails_env,   "production"
set :branch,      "capistrano"

set :application, "#{rails_env}.application_name"
set :deploy_to,   "/home/webuser/www/#{application}"

require 'capistrano-unicorn'