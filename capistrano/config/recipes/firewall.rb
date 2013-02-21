namespace :firewall do
  desc "Setup a firewall with UFW"
  task :setup do
    run "#{sudo} apt-get -y install ufw"
    run "#{sudo} ufw default deny"
    run "#{sudo} ufw allow 22/tcp"
    run "#{sudo} ufw allow 80/tcp"
    run "#{sudo} ufw allow 443/tcp"
    run "#{sudo} ufw --force enable"
  end

  after "deploy:setup", "firewall:setup"
end