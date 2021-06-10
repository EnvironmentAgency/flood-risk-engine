$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flood_risk_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flood_risk_engine"
  s.version     = FloodRiskEngine::VERSION
  s.authors     = ["Digital Services Team, EnvironmentAgency"]
  s.email       = ["dst@environment-agency.gov.uk"]
  s.homepage    = "https://github.com/defra/flood-risk-engine"
  s.summary     = "FloodRiskEngine package containing core elements and functionality"
  s.description = "FloodRiskEngine package containing core elements and functionality"
  s.license     = "The Open Government Licence (OGL) Version 3"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "activerecord-session_store", "~> 2.0"
  # Airbrake catches exceptions and sends them to our instances of Errbit
  # defra_ruby_alert is a gem we created to manage airbrake across projects
  s.add_dependency "defra_ruby_alert", "~> 2.1.1"
  # Manages data seeding
  s.add_dependency "dibber", "~> 0.5"
  # Env Vars drive some config. This loads environment variables from .env
  s.add_dependency "dotenv-rails", "~> 2.1"
  # Used for address lookups on OS Places
  s.add_dependency "defra_ruby_address"
  # Used to determine the EA area for a registered exemption
  s.add_dependency "defra_ruby_area", "~> 2.0"
  # Used as part of testing. When enabled adds a /email/last-email route from
  # which details of the last email sent by the app can be accessed
  s.add_dependency "defra_ruby_email", "~> 1.1"
  s.add_dependency "finite_machine", "~> 0.11.3"
  # Enables url obfuscation with 24bit base58 token
  s.add_dependency "has_secure_token", "~> 1.0.0"
  # Rails engine for static pages. https://github.com/thoughtbot/high_voltage
  s.add_dependency "high_voltage", "~> 3.0"
  s.add_dependency "jquery-rails", ">= 3.1"
  s.add_dependency "nokogiri", ">= 1.11"
  s.add_dependency "os_map_ref", "0.4.2"
  # Add telephone number validation
  s.add_dependency "phonelib", "~> 0.6"
  s.add_dependency "rails", "~> 6.0"
  # Form object convenience
  s.add_dependency "reform", "2.6"
  # Form object convenience (requires reform)
  s.add_dependency "reform-rails", "0.2.2"
  # ActiveJob background processing using another thread
  s.add_dependency "sucker_punch", "~> 2.0.2"
  # The "sync" gem has been removed from ruby 2.17 https://bugs.ruby-lang.org/issues/16170
  # Unfortunately, it is used by finite_machine, so we ensure it is here
  s.add_dependency "sync"
  # Postcode format validation
  s.add_dependency "uk_postcode", "~> 2.1"
  # Validate e-mail addresses against RFC 2822 and RFC 3696
  s.add_dependency "validates_email_format_of", "~> 1.6"
  s.add_dependency "virtus", "~> 1.0"

  # Pretty prints objects in console. Usage `$ ap some_object`
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "bootstrap-sass", "~> 3.3"
  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  s.add_development_dependency "github_changelog_generator"
  s.add_development_dependency "pg", "~> 0.18"
  # Used to ensure the code base matches our agreed styles and conventions
  s.add_development_dependency "rubocop", "0.52"
  s.add_development_dependency "sass-rails", "~> 5.0.4"
end
