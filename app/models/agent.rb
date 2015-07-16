# An Agent is a "bucket" of identities.
class Agent
  # TODO: I have a data structure visitor concept
  # I also want the Agent to eventually be immutable.
  attr_accessor :identities, :verified_authentication_vectors
end
