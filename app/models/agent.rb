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
  def initialize(identifier:, container: default_container, serializer_builder: default_serializer_builder)
    self.identities = container.new
    self.verified_identities = container.new
    self.primary_identifier = identifier
    self.serializer = serializer_builder.call(agent: self)
    self
  end

  # @api public
  Contract(Cogitate::Interfaces::IdentifierInterface => Cogitate::Interfaces::IdentifierInterface)
  def add_identifier(identifier)
    identities << identifier
    identifier
  end

  # @api public
  def with_identifiers
    return enum_for(:with_identifiers) unless block_given?
    identities.each { |identifier| yield(identifier) }
  end

  # @api public
  Contract(Cogitate::Interfaces::IdentifierInterface => Cogitate::Interfaces::IdentifierInterface)
  def add_verified_identifier(identifier)
    verified_identities << identifier
    identifier
  end

  # @api public
  def with_verified_identifiers
    return enum_for(:with_verified_identifiers) unless block_given?
    verified_identities.each { |identifier| yield(identifier) }
  end

  # @return [Cogitate::Interfaces::IdentifierInterface] What has been assigned as the primary identifier of this agent.
  Contract(Contracts::None => Cogitate::Interfaces::IdentifierInterface)
  attr_reader :primary_identifier

  extend Forwardable
  def_delegators :primary_identifier, :strategy, :identifying_value
  def_delegators :serializer, :to_builder, :as_json

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

  attr_accessor :identities, :verified_identities

  Contract(Cogitate::Interfaces::IdentifierInterface => Contracts::Any)
  attr_writer :primary_identifier

  def default_container
    require 'set' unless defined?(Set)
    Set
  end

  attr_accessor :serializer
  def default_serializer_builder
    require 'agent/serializer' unless defined?(Agent::Serializer)
    Agent::Serializer.method(:new)
  end
end
