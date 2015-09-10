require 'cogitate/interfaces'
require 'cogitate/models/identifier'
module Cogitate
  module Models
    class Identifier
      # Responsible for exposing
      class WithAttributeHash
        include Contracts
        Contract(
          Contracts::KeywordArgs[identifier: ::Cogitate::Interfaces::IdentifierInterface, attributes: Contracts::HashOf[String, Any]] =>
          Contracts::Any
        )
        def initialize(identifier:, attributes: {})
          self.identifier = identifier
          self.attributes = attributes
          self.attributes.freeze
        end

        def as_json(*)
          { 'strategy' => strategy, 'identifying_value' => identifying_value }.merge(attributes)
        end

        extend Forwardable
        include Comparable
        def_delegators :identifier, *Cogitate::Models::Identifier.interface_method_names

        attr_reader :attributes

        private

        attr_accessor :identifier
        attr_writer :attributes

        def method_missing(method_name, *args, &block)
          attributes.fetch(method_name.to_s) { super }
        end

        def respond_to_missing?(method_name, *args)
          attributes.key?(method_name.to_s) || super
        end
      end
    end
  end
end
