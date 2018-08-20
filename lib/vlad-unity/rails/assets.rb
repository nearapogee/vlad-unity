namespace :vlad do

  namespace :assets do
    desc "Precomile"
    remote_task :precompile , :roles => :app do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
    end
  end

end
