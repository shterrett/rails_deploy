set :user,        "webuser"

# target
server            "web_server_name_or_ip", :app, :web, primary: true
server            "db_server_name_or_ip", :db, primary: true
set :rails_env,   "staging"
set :branch,      "capistrano"

set :application, "#{rails_env}.application_name"
set :deploy_to,   "/home/webuser/www/#{application}"

require 'capistrano-unicorn'