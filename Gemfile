source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'rest-client', '~> 1.6.7'
gem 'haml', '~> 3.1.7'
gem 'haml-rails', '~> 0.3.4'
gem 'heroku'
gem 'ckeditor_rails'
gem 'recursive-open-struct', '~> 0.2.1', require: 'recursive_open_struct'
gem "paperclip", "~> 3.0"
gem "zendesk_api"
gem "googlecharts", "~> 1.6.8", :require => "gchart"
gem "chartkick"
gem "jscolor-rails"

# gem 'machineshop', :git => 'https://github.com/Mach19/machineshop_gem.git'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :test, :development do
  gem 'sqlite3'
end

group :staging, :production do
  gem 'pg'
  #gem 'sqlite3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'turbo-sprockets-rails3'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "twitter-bootstrap-rails"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

group :test do
  gem 'capybara-webkit', '~> 0.14.0'
  gem 'database_cleaner', '~> 0.9.1'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'launchy', '~> 2.2.0'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'rspec-rails', '~> 2.12.2'
  gem 'spork', '~> 0.9.2'
end

group :development, :test do
  #gem 'pry-doc', '~> 0.4.4'
  gem 'pry-rails', '~> 0.2.2'
  gem 'better_errors', '~> 0.6.0'
  gem 'binding_of_caller', '~> 0.7.1'
  gem 'meta_request', '~> 0.2.1'
  gem 'capistrano', '~> 2.13.5'
  gem 'capistrano-ext', '~> 1.2.1'
  gem 'rvm-capistrano', '~> 1.3.0.rc1'
end

gem 'httparty'
gem 'awesome_print'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'
# Deploy with Capistrano

# gem 'capistrano'

# To use debugger
# gem 'debugger'
