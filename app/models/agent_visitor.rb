require 'set'
require 'cogitate/interfaces'

# Responsible for visiting a node and tracking if the node has already
# been visited.
class AgentVisitor
  include Contracts
  Contract(
    Contracts::KeywordArgs[
      identity_collector_builder: Contracts::Optional[Contracts::Func[Cogitate::Interfaces::AgentCollectorInitializationInterface]]
    ] => Cogitate::Interfaces::VisitorInterface
  )
  def initialize(identity_collector_builder: default_identity_collector_builder)
    self.visited_nodes = Set.new
    self.collector = identity_collector_builder.call(visitor: self)
    self
  end

  # @note We don't want to visit a node more than once. Consider the scenario where we start by finding a Netid. From the Netid, we
  #   see that there is an associated ORCID. Now, from the ORCID we want to make sure we have other related identifiers. And we see that
  #   there is a Netid. If we don't track visitation of that Netid, we may well spiral into infinity.
  def visit(node)
    return node if visited_nodes.include?(node)
    visited_nodes << node
    yield(collector)
    node
  end

  private

  attr_accessor :visited_nodes
  attr_accessor :collector

  def default_identity_collector_builder
    Collector.method(:new)
  end

  DefaultAgent = Struct.new(:identities, :verified_authentication_vectors)

  # A builder for assisting in the generation an Agent. It is the intermediary
  # brokering direct access to an Agent's state.
  class Collector
    include Contracts
    Contract(
      Cogitate::Interfaces::AgentCollectorInitializationInterface => Cogitate::Interfaces::IdentityCollectorInterface
    )
    def initialize(visitor:, agent: default_agent)
      self.agent = agent
      self.visitor = visitor
      self
    end

    Contract(Cogitate::Interfaces::IdentifierInterface => Cogitate::Interfaces::IdentifierInterface)
    def add_identity(input)
      agent.identities << input
      input
    end

    Contract(Cogitate::Interfaces::VerifiedAuthenticationVectorInterface => Cogitate::Interfaces::VerifiedAuthenticationVectorInterface)
    def add_verified_authentication_vector(input)
      agent.verified_authentication_vectors << input
      input
    end

    private

    attr_accessor :agent, :visitor

    def default_agent
      DefaultAgent.new(Set.new, Set.new)
    end
  end
end
