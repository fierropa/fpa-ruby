source 'https://rubygems.org'

gem 'rails', '~> 5.0'
gem 'puma'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'redis-rails'
gem 'redis-namespace'
gem 'devise', git: 'https://github.com/gogovan/devise.git', branch: 'rails-5.1'
gem 'erubis'
gem 'jbuilder', '~> 2.0' 
gem 'rack-cors'
gem 'paperclip'
gem 'state_machine'
gem 'turbolinks'
gem 'RedCloth'

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-rails'#, '~> 1.2'
  gem 'capistrano-passenger'#, '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1'
  
  gem 'letter_opener'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

# START:vanity
gem 'vanity'
# END:vanity

# START:formtastic
gem 'formtastic'
# END:formtastic

# Gems used only for assets and not required
# in production environments by default.
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'sass-rails'
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer'
gem 'uglifier'
gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'



# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# START:test
group :test do
  # START_HIGHLIGHT
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'launchy'
  gem 'database_cleaner'
  # END_HIGHLIGHT
  gem 'turn', :require => false
  gem 'factory_girl'
end
# END:test
 
