require 'figaro'
require 'set'
require 'cogitate/models/agent'

module Cogitate
  module Models
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
          prepare_relationships_and_inclusions!
          {
            'type' => JSON_API_TYPE, 'id' => agent.encoded_id,
            'links' => { 'self' => "#{url_for_identifier(agent.encoded_id)}" },
            'attributes' => { 'strategy' => agent.strategy, 'identifying_value' => agent.identifying_value, 'emails' => emails_as_json },
            'relationships' => { 'identifiers' => identities_as_json, 'verified_identifiers' => verified_identities_as_json },
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

        # @note This method is rather complicated but it reduces the number of times we iterate
        #       through each of the Enumerators.
        def prepare_relationships_and_inclusions!
          included_objects_as_json = Set.new
          identities_as_json = Set.new
          verified_identities_as_json = Set.new

          agent.with_identifiers do |identifier|
            identities_as_json << { 'type' => 'identifiers', 'id' => identifier.encoded_id }
            included_objects_as_json << { 'type' => 'identifiers', 'id' => identifier.encoded_id, 'attributes' => identifier.as_json }
          end

          agent.with_verified_identifiers do |identifier|
            verified_identities_as_json << { 'type' => 'identifiers', 'id' => identifier.encoded_id }
            included_objects_as_json << { 'type' => 'identifiers', 'id' => identifier.encoded_id, 'attributes' => identifier.as_json }
          end

          @included_objects_as_json = included_objects_as_json.to_a
          @identities_as_json = identities_as_json.to_a
          @verified_identities_as_json = verified_identities_as_json.to_a
        end

        attr_reader :included_objects_as_json, :identities_as_json, :verified_identities_as_json

        def url_for_identifier(encoded_identifier)
          "#{Figaro.env.protocol}://#{Figaro.env.domain_name}/api/agents/#{encoded_identifier}"
        end
      end
    end
  end
end
