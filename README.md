# vlad-unity

### A (hopefully) more agnostic set of vlad extensions.

This library fixes some things that might bother you over default vlad tasks
and adds a few more enahncements.

It tries to make vlad less opinionated when having an opinion about being
opinionated.

## Dependencies

- vlad

## Useage

This gem requires you to 

```ruby
# require the files that you want... be a standup citizen

require 'vlad-unity/rails/assets'
set :rails_env, nil

# similar to shared_paths, i.e. { shared file => linked location }
# key of hash is looked for in the shared_path location
#
# 
require 'vlad-unity/extension'
set :shared_files, {
  'neo4j.yml' => 'config/neo4j.yml'
}

require 'vlad-unity/app'
set :start_app, 'vlad:systemd:start'
set :restart_app, 'vlad:systemd:restart'

# Every deploy is its own special flower -- we have a default implementation
# for:
# vlad:app:update
# vlad:deploy
#
# But you can make your own!
#
Rake::Task['vlad:app:update'].clear
namespace :vlad do
  namespace :app do
    Rake::Task['vlad:app:update'].clear
    remote_task :update, :roles => :app do
      Rake::Task['vlad:update_app'].invoke
      Rake::Task['vlad:update_symlinks'].invoke

      # your tasks here

      Rake::Task['vlad:set_current_release'].invoke
      Rake::Task['vlad:log_revision'].invoke
    end
  end

  Rake::Task['vlad:deploy'].clear
  remote_task :deploy, :roles => :app do

    # your tasks here

    Rake::Task['vlad:cleanup'].invoke
  end
end
```

```shell
rake vlad:deploy
```

## Contributors

- Matt Smith, Near Apogee Consulting (www.nearapogee.com)

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

