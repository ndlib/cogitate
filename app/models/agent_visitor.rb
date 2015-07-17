require 'set'
require 'cogitate/interfaces'

# Responsible for visiting a node and tracking if the node has already
# been visited.
class AgentVisitor
  include Contracts
  Contract(
    Contracts::KeywordArgs[agent: Contracts::Optional[Cogitate::Interfaces::AgentBuilderInterface]] =>
    Cogitate::Interfaces::VisitorInterface
  )
  def initialize(agent_builder: default_agent_builder)
    self.visited_nodes = Set.new
    self.agent_builder = agent_builder
    self
  end

  # @note We don't want to visit a node more than once. Consider the scenario where we start by finding a Netid. From the Netid, we
  #   see that there is an associated ORCID. Now, from the ORCID we want to make sure we have other related identifiers. And we see that
  #   there is a Netid. If we don't track visitation of that Netid, we may well spiral into infinity.
  def visit(node)
    return node if visited_nodes.include?(node)
    visited_nodes << node
    yield(agent_builder)
    node
  end

  private

  attr_accessor :visited_nodes
  attr_accessor :agent_builder

  def default_agent_builder
    Builder.new
  end

  DefaultAgent = Struct.new(:identities, :verified_authentication_vectors)

  # A builder for assisting in the generation an Agent. It is the intermediary
  # brokering direct access to an Agent's state.
  class Builder
    include Contracts
    Contract(
      Contracts::KeywordArgs[agent: Contracts::Optional[Cogitate::Interfaces::AgentInterface]] =>
      Cogitate::Interfaces::AgentBuilderInterface
    )
    def initialize(agent: default_agent)
      self.agent = agent
      self
    end

    def add_identity(input)
      agent.identities << input
    end

    def add_verified_authentication_vector(input)
      agent.verified_authentication_vectors << input
    end

    private

    attr_accessor :agent

    def default_agent
      DefaultAgent.new(Set.new, Set.new)
    end
  end
end
