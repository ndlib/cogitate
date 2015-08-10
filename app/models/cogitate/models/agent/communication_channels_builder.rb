require 'cogitate/models/agent'
module Cogitate
  module Models
    class Agent
      # Responsible for extracting the primary communciation channels for each identifier
      #
      # CommunicationChannel - email, telephone number, name, address
      class CommunicationChannelsBuilder
        # @api public
        def self.call(agent:)
          new(agent: agent).call
        end

        def initialize(agent:)
          self.agent = agent
        end

        # @todo Is this a naive assumption?
        def call
          agent.with_identifiers.each do |identifier|
            agent.add_email(identifier.email) if identifier.respond_to?(:email)
          end
          # @todo I wrote a spec for this return value but don't know if it is a requirement
          self
        end

        private

        attr_accessor :agent
      end
    end
  end
end
