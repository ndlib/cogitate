require 'figaro'
require 'jbuilder'
require 'cogitate/interfaces'

class Agent
  # Responsible for the serialization of an Agent
  class Serializer
    # @api public
    def initialize(agent:)
      self.agent = agent
    end

    private

    attr_accessor :agent

    public

    def as_json(*)
      {
        'type' => JSON_API_TYPE, 'id' => agent.encoded_id,
        'links' => { 'self' => "#{url_for_identifier(agent.encoded_id)}" },
        'attributes' => { 'strategy' => agent.strategy, 'identifying_value' => agent.identifying_value, 'emails' => emails_as_json },
        'relationships' => { 'identities' => identities_as_json, 'verified_identities' => verified_identities_as_json },
        'included' => included_objects_as_json
      }
    end

    private

    JSON_API_TYPE = 'agents'.freeze
    def type
      JSON_API_TYPE
    end

    def emails_as_json
      agent.with_emails.each_with_object([]) do |email, mem|
        mem << email
      end
    end

    def included_objects_as_json
      returning_value = Set.new
      collector = lambda do |identity|
        returning_value << {
          'type' => 'identifiers', 'id' => identity.encoded_id, 'attributes' => identity.as_json
        }
      end
      agent.with_identifiers(&collector)
      agent.with_verified_identifiers(&collector)
      returning_value.to_a
    end

    def identities_as_json
      agent.with_identifiers.each_with_object([]) do |identity, mem|
        mem << { 'type' => 'identifiers', 'id' => identity.encoded_id }
      end
    end

    def verified_identities_as_json
      agent.with_verified_identifiers.each_with_object([]) do |identity, mem|
        mem << { 'type' => 'identifiers', 'id' => identity.encoded_id }
      end
    end

    def url_for_identifier(encoded_identifier)
      "#{Figaro.env.protocol}://#{Figaro.env.domain_name}/api/agents/#{encoded_identifier}"
    end
  end
end
