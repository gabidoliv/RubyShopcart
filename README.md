# README

- Ruby version 3.3.3

- System dependencies
  `Rails version 7.1.5.1`
  `Postgres 16`
  `Redis 7.2.6`

- Configuration

  - macOS Sonoma 14.6.1
    `brew services start postgresql@16`
    `brew services start redis`

    `gem install pg --user-install -- --with-pg-config=/opt/homebrew/opt/libpq/bin/pg_config`
    `gem install 'sidekiq-client-cli'`
    `gem install 'sidekiq'`

    > Add `gem 'sidekiq'` and `gem 'rspec'` to Gemfile

    `bundle install`
    `bundle exec sidekiq`
    `bundle exec rails server`

- Database creation
  `bin/rails db:create`

- How to run the test suite
  `bundle exec rspec`
