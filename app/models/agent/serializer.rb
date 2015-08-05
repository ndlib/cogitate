require 'jbuilder'
require 'cogitate/interfaces'

class Agent
  # Responsible for the serialization of an Agent
  class Serializer
    # include Contracts
    # Contract(Cogitate::Interfaces::AgentInterface => RespondTo[:to_builder])
    def initialize(agent:)
      self.agent = agent
      self
    end

    private

    attr_accessor :agent

    public

    def as_json(*)
      {
        'type' => agent.type,
        'id' => agent.id,
        'attributes' => { 'strategy' => agent.strategy, 'identifying_value' => agent.identifying_value },
        'relationships' => { 'identities' => identities_as_json, 'verified_identities' => verified_identities_as_json }
      }
    end

    private

    def identities_as_json
      agent.identities.each_with_object([]) do |identity, mem|
        mem << { 'type' => identity.strategy, 'id' => identity.identifying_value, 'attributes' => identity.as_json }
      end
    end

    def verified_identities_as_json
      agent.verified_identities.each_with_object([]) do |identity, mem|
        mem << { 'type' => identity.strategy, 'id' => identity.identifying_value, 'attributes' => identity.as_json }
      end
    end
  end
end
