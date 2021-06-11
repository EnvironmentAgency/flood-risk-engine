# frozen_string_literal: true

require "defra_ruby/address"

DefraRuby::Address.configure do |configuration|
  configuration.host = ENV["ADDRESSBASE_URL"] || "http://localhost:9002"
  configuration.key = ENV["ADDRESS_FACADE_CLIENT_KEY"]
  configuration.client_id = ENV["ADDRESS_FACADE_CLIENT_ID"]
  configuration.timeout = 10
end
