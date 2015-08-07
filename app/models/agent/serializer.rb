require 'figaro'
require 'jbuilder'
require 'cogitate/interfaces'

class Agent
  # Responsible for the serialization of an Agent
  class Serializer
    def initialize(agent:)
      self.agent = agent
      self
    end

    private

    attr_accessor :agent

    public

    def as_json(*)
      {
        'type' => type, 'id' => id,
        'links' => { 'self' => "#{url_for_self}" },
        'attributes' => { 'strategy' => agent.strategy, 'identifying_value' => agent.identifying_value, 'emails' => emails_as_json },
        'relationships' => { 'identities' => identities_as_json, 'verified_identities' => verified_identities_as_json }
      }
    end

    private

    def id
      Base64.urlsafe_encode64("#{agent.strategy}\t#{agent.identifying_value}")
    end

    JSON_API_TYPE = 'agents'.freeze
    def type
      JSON_API_TYPE
    end

    def emails_as_json
      agent.with_emails.each_with_object([]) do |email, mem|
        mem << email
      end
    end

    def identities_as_json
      agent.with_identifiers.each_with_object([]) do |identity, mem|
        mem << { 'type' => identity.strategy, 'id' => identity.identifying_value, 'attributes' => identity.as_json }
      end
    end

    def verified_identities_as_json
      agent.with_verified_identifiers.each_with_object([]) do |identity, mem|
        mem << { 'type' => identity.strategy, 'id' => identity.identifying_value, 'attributes' => identity.as_json }
      end
    end

    def url_for_self
      "#{Figaro.env.protocol}://#{Figaro.env.domain_name}/api/agents/#{id}"
    end
  end
end
