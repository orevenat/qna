# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, 'qna'
set :repo_url, 'git@github.com:orevenat/qna.git'

set :deploy_to, '/home/deployer/qna/'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/master.key', '.env'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'
