require 'set'
require 'cogitate/interfaces'
require 'agent'

class Agent
  # Responsible for visiting a host and tracking if the host has already
  # been visited.
  class Visitor
    include Contracts
    Contract(
      Contracts::KeywordArgs[
        identifier: Cogitate::Interfaces::IdentifierInterface, agent: Contracts::Optional[Cogitate::Interfaces::AgentInterface]
      ] => Cogitate::Interfaces::VisitorV2Interface
    )
    def self.build(identifier:, agent_builder: default_agent_builder)
      agent = agent_builder.call(identifier: identifier)
      new(agent: agent)
    end

    def self.default_agent_builder
      Agent.method(:new)
    end

    private_class_method :default_agent_builder

    include Contracts
    Contract(
      Contracts::KeywordArgs[
        agent: Cogitate::Interfaces::AgentInterface,
        identity_collector_builder: Contracts::Optional[Contracts::Func[Cogitate::Interfaces::AgentCollectorInitializationInterface]]
      ] => Cogitate::Interfaces::VisitorV2Interface
    )
    def initialize(agent:, identity_collector_builder: default_identity_collector_builder)
      self.visited_hosts = Set.new
      self.collector = identity_collector_builder.call(visitor: self, agent: agent)
      self
    end

    # @note We don't want to visit a host more than once. Consider the scenario where we start by finding a Netid. From the Netid, we
    #   see that there is an associated ORCID. Now, from the ORCID we want to make sure we have other related identifiers. And we see that
    #   there is a Netid. If we don't track visitation of that Netid, we may well spiral into infinity.
    def visit(host)
      return host if visited_hosts.include?(host)
      visited_hosts << host
      yield(collector)
      host
    end

    Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
    def return_from_visitations
      # Poking into the inner workings of the collector; I could rely on
      # reference to the object, but I'd prefer to be more explicit. Yes
      # this violates encapsulation, but I'm at a loss for other options.
      collector.send(:agent)
    end

    private

    attr_accessor :visited_hosts
    attr_accessor :collector

    def default_identity_collector_builder
      Agent::Collector.method(:new)
    end
  end

  # A builder for assisting in the generation an Agent. It is the intermediary
  # brokering direct access to an Agent's state.
  class Collector
    include Contracts
    Contract(Cogitate::Interfaces::AgentCollectorInitializationInterface => Cogitate::Interfaces::IdentityCollectorInterface)
    def initialize(visitor:, agent:)
      self.agent = agent
      self.visitor = visitor
      self
    end

    # @note This may look a little funky but the given visitor is making sure it does not visit a host more than once.
    def visit(host, &block)
      visitor.visit(host, &block)
    end

    Contract(Cogitate::Interfaces::IdentifierInterface => Cogitate::Interfaces::IdentifierInterface)
    def add_identity(input)
      agent.identities << input
      input
    end

    Contract(Cogitate::Interfaces::VerifiedIdentifierInterface => Cogitate::Interfaces::VerifiedIdentifierInterface)
    def add_verified_authentication_vector(input)
      agent.verified_authentication_vectors << input
      input
    end

    private

    attr_accessor :agent, :visitor
  end
end
