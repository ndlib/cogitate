require 'set'
require 'cogitate/interfaces'

# Responsible for visiting a node and tracking if the node has already
# been visited.
class AgentVisitor
  DefaultAgent = Struct.new(:identities, :verified_authentication_vectors)

  include Contracts
  Contract(
    Contracts::KeywordArgs[agent: Contracts::Optional[Cogitate::Interfaces::AgentInterface]] => Cogitate::Interfaces::VisitorInterface
  )
  def initialize(agent: default_agent)
    self.visited_nodes = Set.new
    self.agent = agent
    self
  end

  # @note We don't want to visit a node more than once. Consider the scenario where we start by finding a Netid. From the Netid, we
  #   see that there is an associated ORCID. Now, from the ORCID we want to make sure we have other related identifiers. And we see that
  #   there is a Netid. If we don't track visitation of that Netid, we may well spiral into infinity.
  def visit(node)
    return node if visited_nodes.include?(node)
    visited_nodes << node
    yield(agent)
    node
  end

  private

  attr_accessor :visited_nodes, :agent

  def default_agent
    DefaultAgent.new(Set.new, Set.new)
  end
end
