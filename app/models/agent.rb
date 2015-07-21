require 'cogitate/interfaces'

# An Agent is a "bucket" of attributes. It represents a single acting entity:
#
# * a Person - the human clacking away at the keyboard requesting things
# * a Service - an application that "does stuff" to data
class Agent
  include Contracts
  Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
  def initialize(container: default_container)
    self.identities = container.new
    self.verified_authentication_vectors = container.new
    self
  end

  # @return [Enumerable] These are identities that this Agent makes claims to; However the claims have not been confirmed by a third-party.
  attr_reader :identities

  # @return [Enumerable] These are identifiers (and associated information) that has been verified
  attr_reader :verified_authentication_vectors

  private

  attr_writer :identities, :verified_authentication_vectors

  def default_container
    require 'set' unless defined?(Set)
    Set
  end
end
