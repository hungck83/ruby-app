# config valid only for current version of Capistrano
lock "3.8.2"

set :application, "ruby-app"
set :repo_url, "git@github.com:hungck83/ruby-app.git"

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, {
  path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

# Default value for keep_releases is 5
set :keep_releases, 15
set :rbenv_type, :system
set :rbenv_ruby, '2.4.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :pty, false

# SSHKit.conifg
SSHKit.config.command_map[:rake] = 'bundle exec rake'

set :ssh_options, {
  user: fetch(:user),
  forward_agent: true
}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
