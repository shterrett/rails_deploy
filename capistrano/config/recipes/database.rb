namespace :database do

  desc "put example yml file in place"
  task :create_yml do
    # generate and put the database.yml file in place
    template "database.yml.erb", "/tmp/database.yml"
    run "mkdir -p /home/webuser/www/#{rails_env}.application_name/shared/config/"

    run "#{sudo} mv /tmp/database.yml /home/webuser/www/#{rails_env}.application_name/shared/config/database.yml"
    run "#{sudo} chmod 664 /home/webuser/www/#{rails_env}.application_name/shared/config/database.yml"
    run "#{sudo} chown webuser:webuser /home/webuser/www/#{rails_env}.application_name/shared/config/database.yml"
  end

  after "deploy:setup", "database:create_yml"

end