web: bundle exec puma -C config/puma.rb
worker: bin/jobs
release: DB_POOL=2 bundle exec rake db:migrate_if_tables
