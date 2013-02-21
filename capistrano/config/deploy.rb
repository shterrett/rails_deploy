require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :ruby_version, 'ruby-1.9.3-p194'
set :rvm_gemset, 'application_named_gemset'
set :rvm_ruby_string, "#{ruby_version}@#{rvm_gemset}" # Or whatever env you want it to run in.

require 'capistrano_colors'

set :use_sudo, false
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :user, "webuser"  # The server's user for deploys


########
## use this if you want to deploy from remote git repo
########
#set :scm,           :git
#set :repository,    "application_github_repository"
#set :deploy_via,    :remote_cache

########
## use this if you want to deploy HEAD from local machine
########
# set :scm,               :git
# set :repository,        "file://."
# set :deploy_via,        :copy

########
## use this if you want to deploy the actual contents of local directory
########
set :scm,               :none
set :repository,        "."
set :deploy_via,        :copy


set :copy_exclude,      [".git/*", "log/*", "coverage/*", ".DS_Store", "*.sql", "._*"]

set :bundle_flags, '--deployment'
require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/database"
load "config/recipes/firewall"
# load "config/recipes/monit"
load "config/recipes/nginx"
load "config/recipes/tail"
load "config/recipes/unicorn"
load "config/recipes/utils"


before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:
before 'deploy:setup', 'rvm:create_gemset' # only create gemset


after "bundle:install",
"deploy:update_shared_symlinks"
"deploy:migrate"

after "deploy",
  "deploy:cleanup"

before "deploy:assets:precompile", "deploy:link_db"

namespace :deploy do
  desc "Update shared symbolic links"
  task :update_shared_symlinks do
    run "mkdir -p #{deploy_to}/shared/config"
    run "mkdir -p #{deploy_to}/shared/config/unicorn"
    shared_files = ["config/unicorn/#{rails_env}.rb"]
    commands_array = []
    shared_files.each do |path|
      commands_array.push "rm -rf #{File.join(release_path, path)};"
      commands_array.push "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)};"
    end
    # we concatenate the commands to make the script faster.  One command gets executed instead of 1 per file.
    concatenated_commands = commands_array.join
    run concatenated_commands
  end
  task :link_db do
    run "ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end

