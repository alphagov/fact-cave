source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mongo_mapper', '0.12.0'
gem 'bson_ext', '1.9.2'

gem 'mysql2', '0.3.11'

gem 'exception_notification', '3.0.1'
gem 'aws-ses', '0.5.0', :require => 'aws/ses'

gem 'unicorn', '4.6.2'

gem 'plek', '1.3.1'
gem 'gds-sso', '3.0.3'

gem 'therubyracer', '0.11.4'
gem 'less-rails-bootstrap', '2.3.2'
gem 'jquery-rails', '2.2.1'

group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '2.13.2'
  gem 'simplecov-rcov', '0.2.3', :require => false
  gem 'ci_reporter', '1.8.4'
  gem 'capybara', '2.0.3' # 2.1.0 doesn't work on ruby 1.9.2
  gem 'factory_girl_rails', '4.2.1'
  gem 'database_cleaner', '1.1.1'
end
