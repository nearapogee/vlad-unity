namespace :vlad do
  # Override the default update.
  #
  Rake::Task['vlad:update'].clear
  remote_task :update, :roles => :app do
    Rake::Task['vlad:update_app'].invoke
    Rake::Task['vlad:update_symlinks'].invoke
    Rake::Task['vlad:set_current_release'].invoke
    Rake::Task['vlad:log_revision'].invoke
  end

  # Set start_app to call :start.
  #
  remote_task :start_app, :roles => :app do
    unless (Rake::Task[start_app] rescue false)
      raise <<-ERR
start_app must defiened. i.e. `set :start_app, 'vlad:systemd:start'`"
      ERR
    end
    Rake::Task[start_app].invoke
  end

  namespace :app do
    remote_task :update, :roles => :app do
      Rake::Task['vlad:update_app'].invoke
      Rake::Task['vlad:update_symlinks'].invoke

      if (Rake::Task['vlad:bundle:install'] rescue false)
        Rake::Task['vlad:bundle:install'].invoke
      end
      if (Rake::Task['vlad:migrate'] rescue false)
        Rake::Task['vlad:migrate'].invoke
      end
      if (Rake::Task['vlad:assets:precompile'] rescue false)
        Rake::Task['vlad:assets:precompile'].invoke unless ENV['SKIP_ASSETS']
      end

      Rake::Task['vlad:set_current_release'].invoke
      Rake::Task['vlad:log_revision'].invoke
    end
  end

  desc "Deploy application and start servers."
  remote_task :deploy, :roles => :app do
    unless (Rake::Task[restart_app] rescue false)
      raise <<-ERR
restart_app must defiened. i.e. `set :restart_app' 'vlad:systemd:restart'`"
      ERR
    end
    Rake::Task['vlad:app:update'].invoke
    Rake::Task[restart_app].invoke
    Rake::Task['vlad:cleanup'].invoke
  end

end
