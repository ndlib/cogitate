require 'set'
require 'cogitate/interfaces'
require 'cogitate/models/agent'

module Cogitate
  module Models
    class Agent
      # Responsible for visiting a host and tracking if the host has already
      # been visited.
      class Visitor
        include Contracts
        extend Contracts
        Contract(
          Contracts::KeywordArgs[
            identifier: Cogitate::Interfaces::IdentifierInterface, communication_channels_builder: Contracts::Optional[RespondTo[:call]]
          ] => Cogitate::Interfaces::VisitorV2Interface
        )
        def self.build(identifier:, agent_builder: default_agent_builder, **keywords)
          agent = agent_builder.call(identifier: identifier)
          new(agent: agent, **keywords)
        end

        def self.default_agent_builder
          Agent.method(:new)
        end

        private_class_method :default_agent_builder

        include Contracts
        Contract(
          Contracts::KeywordArgs[
            agent: Cogitate::Interfaces::AgentInterface,
            communication_channels_builder: Contracts::Optional[RespondTo[:call]]
          ] => Cogitate::Interfaces::VisitorV2Interface
        )
        def initialize(agent:, communication_channels_builder: default_communication_channels_builder)
          self.visited_hosts = Set.new
          self.agent = agent
          self.communication_channels_builder = communication_channels_builder
          self
        end

        # @api public
        #
        # Responsible for coordinating the visit with a given `host`; As per the implementation
        # only visit each host once.
        #
        # @param host [Object] Some thing that can "host" a visit.
        # @yieldparam visitor [Cogitate::Models::Agent::Visitor] If the host has already been visited, yield the visitor
        # @return host
        #
        # @note We don't want to visit a host more than once. Consider the scenario where we start by finding a Netid. From the Netid, we
        #   see that there is an associated ORCID. Now, from the ORCID we want to make sure we have other related identifiers. And we see
        #   that there is a Netid. If we don't track visitation of that Netid, we may well spiral into infinity.
        def visit(host)
          return host if visited_hosts.include?(host)
          visited_hosts << host
          yield(self)
          host
        end

        Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
        def return_from_visitations
          communication_channels_builder.call(agent: agent)
          agent
        end

        extend Forwardable
        def_delegators :agent, :add_identifier, :add_identifier, :add_verified_identifier

        private

        attr_accessor :visited_hosts
        attr_accessor :agent
        attr_accessor :communication_channels_builder

        def default_communication_channels_builder
          require 'cogitate/models/agent/communication_channels_builder' unless defined?(Agent::CommunicationChannelsBuilder)
          Cogitate::Models::Agent::CommunicationChannelsBuilder
        end
      end
    end
  end
end
