require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      # This class is in place to say "You said you had this identifier, so I'll add it as an identity though I don't know much about it."
      # @api public
      class ParrotingStrategy
        extend Contracts
        Contract(Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Cogitate::Interfaces::HostInterface)
        def self.call(identifier:)
          new(identifier: identifier)
        end

        def initialize(identifier:)
          self.identifier = identifier
        end

        def invite(guest)
          guest.visit(identifier) { |visitor| visitor.add_identity(identifier) }
        end

        private

        attr_accessor :identifier
      end
    end
  end
end
