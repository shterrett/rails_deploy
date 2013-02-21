namespace :tail do

  desc "tail rails log files"
  task :rails_log, :roles => :app do
    run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
      # puts  # for an extra line break before the host name
      # puts "#{channel[:host]} [#{rails_env.upcase}]: #{data}"

      puts "#{data}"
      break if stream == :err
    end
  end

##  desc "tail sidekiq log files"
##  task :sidekiq_log, :roles => :app do
##    run "tail -f #{shared_path}/log/sidekiq.log" do |channel, stream, data|
##      # puts  # for an extra line break before the host name
##      puts "#{channel[:host]} [#{rails_env.upcase}]: #{data}"
##      break if stream == :err
##    end
##  end
##
##  desc "tail whenever(cron) log files"
##  task :whenever_log, :roles => :app do
##    run "tail -f #{shared_path}/log/cron_whenever.log" do |channel, stream, data|
##      puts "#{channel[:host]} [#{rails_env.upcase}]: #{data}"
##      break if stream == :err
##    end
##  end

  desc "tail unicorn log files"
  task :unicorn_log, :roles => :app do
    run "tail -f #{shared_path}/log/unicorn.log" do |channel, stream, data|
      puts "#{channel[:host]} [#{rails_env.upcase}]: #{data}"
      break if stream == :err
    end
  end

  desc "tail nginx_access log files"
  task :nginx_access_log, :roles => :app do
    run "tail -f #{shared_path}/../../nginx_access.log" do |channel, stream, data|
      puts "#{channel[:host]} [#{rails_env.upcase}]: #{data}"
      break if stream == :err
    end
  end

  desc "tail nginx_error log files"
  task :nginx_error_log, :roles => :app do
    run "tail -f #{shared_path}/../../nginx_error.log" do |channel, stream, data|
      puts "#{channel[:host]} [#{rails_env.upcase}]: #{data}"
      break if stream == :err
    end
  end

end
