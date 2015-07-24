require 'cogitate/interfaces'
require 'base64'

# @api public
#
# An Agent is a "bucket" of attributes. It represents a single acting entity:
#
# * a Person - the human clacking away at the keyboard requesting things
# * a Service - an application that "does stuff" to data
class Agent
  include Contracts
  # @note I'm choosing the :identifier as the input and :primary_identifier as the attribute. I believe it is possible that during the
  #       process that builds the Agent, I may encounter a more applicable primary_identifier.
  Contract(Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Cogitate::Interfaces::AgentInterface)
  def initialize(identifier:, container: default_container)
    self.identities = container.new
    self.verified_authentication_vectors = container.new
    self.primary_identifier = identifier
    self
  end

  # @api public
  #
  # @return [Enumerable] These are identities that this Agent makes claims to; However the claims have not been confirmed by a third-party.
  attr_reader :identities

  # @return [Enumerable] These are identifiers (and associated information) that has been verified
  attr_reader :verified_authentication_vectors

  # @return [Cogitate::Interfaces::IdentifierInterface] What has been assigned as the primary identifier of this agent.
  Contract(Contracts::None => Cogitate::Interfaces::IdentifierInterface)
  attr_reader :primary_identifier

  extend Forwardable
  def_delegators :primary_identifier, :strategy, :identifying_value

  JSON_API_TYPE = 'agents'.freeze
  def type
    JSON_API_TYPE
  end

  def id
    # Pass this on to the identifier
    # TODO: This is a property of the identifier
    Base64.urlsafe_encode64("#{strategy}\t#{identifying_value}")
  end

  private

  attr_writer :identities, :verified_authentication_vectors

  Contract(Cogitate::Interfaces::IdentifierInterface => Contracts::Any)
  attr_writer :primary_identifier

  def default_container
    require 'set' unless defined?(Set)
    Set
  end
end
