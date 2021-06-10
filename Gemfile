source "https://rubygems.org"

# Declare your gem's dependencies in flood_risk_engine.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :development, :test do
  # ActiveRecord N+1 detection
  gem "bullet"
  # Call "byebug" anywhere in the code to stop execution and get a debugger
  # console
  gem "byebug", "~> 11.0.1" # 11.1 only supports Ruby 2.4 and up
end

group :test do
  gem "capybara", "~> 3.35.3"
  gem "database_cleaner", "~> 2.0.1"
  gem "email_spec"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 2.17.0"
  gem "poltergeist", "~> 1.9" # Needed for headless testing with Javascript or pages that ref external sites
  gem "rails-controller-testing"
  gem "rspec-html-matchers"
  gem "rspec-rails", "~> 5.0.1"
  gem "shoulda-matchers", "~> 4.5.1", require: false
  gem "simplecov", "~> 0.21.2", require: false
  gem "vcr", "~> 6.0.0"
  gem "webmock", "~> 3.13"
end
