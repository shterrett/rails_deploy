namespace :rvm do
  desc "set trust flag"
  task :set_trust_flag do
    run "echo 'rvm_trust_rvmrcs_flag=1' >> /home/webuser/.rvmrc"
  end

  after 'rvm:create_gemset', 'rvm:set_trust_flag'
end


def disable_rvm_shell(&block)
  old_shell = self[:default_shell]
  self[:default_shell] = nil
  yield
  self[:default_shell] = old_shell
end