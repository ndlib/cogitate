require 'forwardable'
require 'cogitate/interfaces'
require 'cogitate/models/identifier'

module Cogitate
  module Models
    module Identifiers
      # Responsible for exposing
      class WithAttributeHash
        include Contracts
        Contract(
          Contracts::KeywordArgs[
            identifier: ::Cogitate::Interfaces::IdentifierInterface, attributes: Contracts::HashOf[Contracts::Or[String, Symbol], Any]
          ] => Contracts::Any
        )
        def initialize(identifier:, attributes: {})
          self.identifier = identifier
          self.attributes = attributes
          self.attributes.freeze
        end

        def as_json(*)
          { 'name' => name, 'identifying_value' => identifying_value, 'strategy' => strategy }.merge(attributes)
        end

        extend Forwardable
        include Comparable
        def_delegators :identifier, *Cogitate::Models::Identifier.interface_method_names

        attr_reader :attributes

        private

        attr_accessor :identifier

        def method_missing(method_name, *args, &block)
          attributes.fetch(method_name.to_s) { super }
        end

        def respond_to_missing?(method_name, *args)
          attributes.key?(method_name.to_s) || super
        end

        def attributes=(input)
          @attributes = input.each_with_object({}) do |(key, value), mem|
            mem[key.to_s] = value
            mem
          end
        end
      end
    end
  end
end
