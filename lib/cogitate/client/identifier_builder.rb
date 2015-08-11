require 'cogitate/models/identifier'
require 'cogitate/models/identifier/with_attribute_hash'

module Cogitate
  module Client
    # Responsible for transforming an encoded identifier into an identifier
    # then decorating that identifier with attributes that may be found in the
    # array of :included objects
    #
    # @see Cogitate::Models::Identifier
    # @see Cogitate::Client::IdentifierBuilder.call
    module IdentifierBuilder
      # @api public
      def self.call(encoded_identifier:, included: [], identifier_decoder: default_identifier_decoder)
        base_identifier = identifier_decoder.call(encoded_identifier: encoded_identifier)
        included_object = included.detect { |obj| obj['id'] == encoded_identifier }
        if included_object
          Models::Identifier::WithAttributeHash.new(identifier: base_identifier, attributes: included_object.fetch('attributes', {}))
        else
          base_identifier
        end
      end

      def self.default_identifier_decoder
        require 'cogitate/services/identifiers_decoder' unless defined? Services::IdentifiersDecoder
        ->(encoded_identifier:) { Services::IdentifiersDecoder.call(encoded_identifier).first }
      end
    end
  end
end
