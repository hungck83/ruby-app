set :rails_env, :staging_vn
set :user, 'zigexn'
ask :branch, 'master'

server '192.168.1.57', user: 'zigexn', roles: %w{docker}

set :ssh_options, {
keys: %w(~/.ssh/id_rsa),
forward_agent: false, }


namespace :nginx do
  desc "restart nginx"
  task :restart do
    on roles(:app) do
      execute "sudo /etc/init.d/nginx status"
      execute "sudo /etc/init.d/nginx restart"
      execute "sudo /etc/init.d/nginx status"
    end
  end
end

after "deploy:finished", 'nginx:restart'
