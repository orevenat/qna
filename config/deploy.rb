# frozen_string_literal: true

lock '~> 3.11.2'

set :rvm_type, :user
set :rvm_ruby_version, '2.6.3'

set :application, 'qna'
set :repo_url, 'git@github.com:orevenat/qna.git'

set :deploy_to, '/home/deployer/qna/'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/master.key', '.env'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

set :sidekiq_pid, -> { 'tmp/pids/sidekiq.pid' }
