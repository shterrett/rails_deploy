namespace :monit do
  desc "Setup monit configuration for this application"
  task :setup do
    template "monitrc.erb", "/tmp/monitrc"
    run "#{sudo} mv /tmp/monitrc /etc/monit/monitrc"

    # delete old stanzas
    run "#{sudo} rm -rf /etc/monit/conf.d/*"

    # put new stanzas in place
    Dir.glob(File.join(File.dirname(__FILE__), '/templates/monit_stanzas/*')).sort.each do |f|
      fname_relative = f.split("./config/recipes/templates/").last
      fname_simple = f.gsub('.erb', '').split("/").last
      template fname_relative, "/tmp/#{fname_simple}"
      run "#{sudo} mv /tmp/#{fname_simple} /etc/monit/conf.d/#{fname_simple}"
    end

    # set permissions
    run "#{sudo} chown -R root:root /etc/monit"

    restart
  end

  %w[start stop restart].each do |command|
    desc "#{command} monit"
    task command do
      sudo "/etc/init.d/monit #{command}"
    end
  end

  after "deploy:setup", "monit:setup"
end