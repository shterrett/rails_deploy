set_default(:nginx_workers) { (rails_env.eql? 'production') ? "4" : "1" }

namespace :nginx do
  task :setup do
    # main nginx conf
    template "nginx.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/nginx.conf"

    # nginx unicorn conf for environment
    template "nginx_unicorn.erb", "/tmp/nginx_unicorn_conf"
    run "#{sudo} mv /tmp/nginx_unicorn_conf /etc/nginx/sites-enabled/#{application}"

    # delete the default conf if it exist
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"

    restart
  end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      run "#{sudo} service nginx #{command}"
    end
  end

end
