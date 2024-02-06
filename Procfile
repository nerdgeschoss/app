web: bundle exec puma -C config/puma.rb
worker: bundle exec rake solid_queue:start
release: DB_POOL=2 bundle exec rake db:migrate_if_tables
