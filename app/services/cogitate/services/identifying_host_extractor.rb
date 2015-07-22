require 'contracts'
require 'cogitate/interfaces'
require 'active_support/inflector/methods'
require 'cogitate/services/identifying_host_extractor/parroting_strategy'

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
        hosting_strategy = find_hosting_strategy(identifier: identifier)
        hosting_strategy.call(identifier: identifier)
      end

      def self.find_hosting_strategy(identifier:)
        # Instead of loading all of ActiveSupport make an explicit declaration.
        strategy_constant_name = ActiveSupport::Inflector.classify("#{identifier.strategy}_strategy")
        begin
          const_get(strategy_constant_name)
        rescue NameError
          fallback_hosting_strategy
        end
      end
      private_class_method :find_hosting_strategy

      def self.fallback_hosting_strategy
        ParrotingStrategy
      end
      private_class_method :fallback_hosting_strategy
    end
  end
end
