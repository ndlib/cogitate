require 'cogitate/configuration'

# Cogitate is a federated identity management system for managing:
#   * User identities through:
#     * Group membership
#     * Alternate authentication strategies (ORCID, email, etc.)
#     * Non-verifiable identities (Preferred Name, Scopus, etc.)
#     * Parroted identities (ask for the identity of a Kroger Card number, you'll get back a Kroger card number)
#   * User authentication through various providers
module Cogitate
  # This version reflects the gem version for release
  VERSION = '0.0.2'.freeze

  def self.configure
    yield(configuration)
  end

  def self.configuration=(input)
    @configuration = input
  end

  def self.configuration
    @configuration ||= Cogitate::Configuration.new
  end
end

require 'cogitate/railtie' if defined?(Rails)
