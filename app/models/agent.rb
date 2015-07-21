# An Agent is a "bucket" of identities.
require 'set'

class Agent
  def initialize
    self.identities = Set.new
    self.verified_authentication_vectors = Set.new
  end

  attr_reader :identities, :verified_authentication_vectors

  private

  attr_writer :identities, :verified_authentication_vectors
end
