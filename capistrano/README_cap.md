Copy the files in this directory into their corresponding locations in the Rails application

Changes:
=====
	- config/deploy/production.rb and config/deploy/staging.rb
		server name/ip and application name
	- config/environments/staging.rb
		this file should be created in the existing config/environments directory. The production.rb file's contents should be copied into it
	- config/deploy.rb
		"application_named_gemset" 
		choose deploy method
			application_github_repository
	-config/recipes
		- database.rb
			application_name
		- templates
			- database.yml.erb: This file will be copied to the server and symlinked into the "current". The database password should be input in the file on the server, and NOT in this template file. 
				database_name
				database_server_name_or_ip --> change after deploy; different for staging and production
			- nginx_unicorn.erb
				url_used_to_access_application
				application_name
				uncomment ssl section if requried
			- unicorn_init.erb				
				application_name
			- unicorn.rb.erb
			
			
Database.yml
=====
The local database.yml file should be .gitignored. The Capistrano script will create a database.yml file from teh file in templates. Once on the server, this file will need to have the password filled in so that the connection will work. This servers to keep the database password out of the remote repo.

Deployment
======

1. Make sure /etc/sudoers has this setting; otherwise nothing will work.

    ** Fabric script should do this for you. **
    %sudo   ALL=NOPASSWD: ALL

2. Create database on target server and give appropriate permissions (see goodtoknow for sql commands).
  mysql> create database <database_name>;
  mysql> grant usage on *.* to <db_user>@<webserver_ip> identified by ‘db_user_password’;
  mysql> grant all privileges on <database_name>.* to <db_user>@<webserver_ip>;
  

3. Put the two SSL cert files in place.  Find the files on Dropbox.

    $ sudo mkdir /etc/nginx/certs
    $ sudo nano /etc/nginx/certs/api.<stage>.<application_name>.chain.cert
    $ sudo nano /etc/nginx/certs/privkey.pem

    $ sudo chmod 755 /etc/nginx/certs
    $ sudo chown -R root:root /etc/nginx/certs

4. Deploy directory setup

    $ cap [stage] deploy:setup

5. Edit database.yml in shared directory

    $ nano /home/ravidapp/www/<stage>.ravidapp.com/shared/config/database.yml

6. ... and deploy(cold)

    $ cap [stage] deploy:cold

7. Rename server hostname

    $ sudo nano /etc/hostname
    $ sudo nano /etc/hosts

8. Reboot

    $ sudo reboot

9.
    $ cap <stage> unicorn:setup
    $ cap <stage> nginx:setup
    $ cap <stage> unicorn:start (may be necssary)

10. optional - install & configure server monitoring (copperegg, monit, etc)

  