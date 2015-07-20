require 'contracts'
require 'cogitate/interfaces'
require 'active_support/inflector/methods'

module Cogitate
  module Services
    # Responsible for inviting a guest to visit the given identifier.
    # @see .call for more details
    module IdentifyingHostExtractor
      extend Contracts

      Contract(
        Contracts::KeywordArgs[
          identifier: Cogitate::Interfaces::IdentifierInterface, visitor: Cogitate::Interfaces::VisitorInterface
        ] => Contracts::Any
      )
      # @todo Refine what the expected return value is
      def self.call(identifier:, visitor:)
        host = identifying_host_for(identifier: identifier)
        host.invite(visitor)
      end

      # @api public
      # @todo What is the constant missing behavior?
      Contract(
        Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Cogitate::Interfaces::HostInterface
      )
      def self.identifying_host_for(identifier:)
        # Instead of loading all of ActiveSupport make an explicit declaration.
        strategy_constant_name = ActiveSupport::Inflector.classify("#{identifier.strategy}_strategy")
        const_get(strategy_constant_name).call(identifier: identifier)
      end
    end
  end
end
