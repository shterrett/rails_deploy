set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{shared_path}/pids/unicorn.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn/#{rails_env}.rb" }
set_default(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
set_default(:unicorn_workers) { (rails_env.eql? 'production') ? "4" : "1" }

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config/unicorn"

    # generate and put the unicorn.rb file in place
    template "unicorn.rb.erb", unicorn_config

    # generate the unicorn init.d startup script and put in place
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn"

    # and register the unicorn script to start on reboot
    run "#{sudo} update-rc.d -f unicorn defaults"    
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "service unicorn #{command}"
    end
  end

end