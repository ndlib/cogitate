require 'cogitate/models/agent'

module Cogitate
  module Client
    # Responsible for transforming a Hash into an Agent and its constituent parts.
    module AgentBuilder
      module_function

      def call(data, identifier_decoder: default_identifier_decoder)
        identifier = identifier_decoder.call(data.fetch('id'))
        Models::Agent.new(identifier: identifier) do |agent|
          data.fetch('attributes').fetch('emails').each { |email| agent.add_email(email) }
          # TODO: Add any included information
          data.fetch('relationships').fetch('identifiers').each do |stub|
            agent.add_identifier(identifier_decoder.call(stub.fetch('id')))
          end
          data.fetch('relationships').fetch('verified_identifiers').each do |stub|
            agent.add_verified_identifier(identifier_decoder.call(stub.fetch('id')))
          end
        end
      end

      # @api private
      # Because the identifiers decoder returns an array; However I want a single object.
      def default_identifier_decoder
        require 'cogitate/services/identifiers_decoder' unless defined? Services::IdentifiersDecoder
        ->(encoded_id) { Services::IdentifiersDecoder.call(encoded_id).first }
      end
      private_class_method :default_identifier_decoder
    end
  end
end
