# config valid only for Capistrano 3.1
lock '3.4.0'
set :default_env, path: "/opt/ruby/current/bin:$PATH"
set :bundle_roles, [:app, :work]
set :bundle_flags, "--deployment --path=vendor/bundle"
set :bundle_cmd, "/opt/ruby/current/bin/bundle"
set :bundle_without, %w{development test documentation}.join(' ')
set :application, 'cogitate'
set :scm, :git
set :repo_url, "https://github.com/ndlib/cogitate.git"
set :branch, ENV['BRANCH_NAME'] || 'master'
set :keep_releases, 5
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :secret_repo_name, proc {
  case fetch(:rails_env)
  when 'staging' then 'secret_staging'
  when 'pre_production' then 'secret_pprd'
  when 'production' then 'secret_prod'
  end
}
set :passenger_restart_with_touch, true

namespace :deploy do
  task :db_create do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc 'Perform data migrations via db/data'
  task :data_migrate do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:data:migrate"
        end
      end
    end
  end
end

namespace :configuration do
  task :copy_secrets do
    on roles(:app) do
      within release_path do
        execute "export PATH=/opt/ruby/current/bin:$PATH && cd #{release_path} && sh scripts/update_secrets.sh #{fetch(:secret_repo_name)}"
      end
    end
  end
end

before 'deploy:migrate', 'configuration:copy_secrets'
after 'deploy:migrate', 'deploy:data_migrate'
after 'deploy', 'deploy:cleanup'
after 'deploy', 'deploy:restart'

require './config/boot'
require 'airbrake/capistrano3'
