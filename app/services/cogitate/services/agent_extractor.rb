require 'contracts'
require 'cogitate/interfaces'
require 'active_support/inflector/methods'

module Cogitate
  module Services
    # Responsible for brokering the IdentityExtraction
    module AgentExtractor
      extend Contracts
      # @todo Define the contract for what should be returned by call
      Contract(Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Contracts::Any)
      def self.call(identifier:)
        find_strategy_specific_extractor(identifier).call
      end

      def self.find_strategy_specific_extractor(identifier)
        # Instead of loading all of ActiveSupport make an explicit declaration.
        strategy_constant_name = ActiveSupport::Inflector.classify("#{identifier.strategy}_strategy")
        const_get(strategy_constant_name).new(identifier: identifier)
      end
      private_class_method :find_strategy_specific_extractor
    end
  end
end
