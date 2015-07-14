require 'active_support/inflector/methods'

module Cogitate
  module Services
    # Responsible for brokering the IdentityExtraction
    module AgentExtractor
      module_function

      # @param identifier [Cogitate::Parameters::Identifier]
      def call(identifier:)
        find_strategy_specific_extractor(identifier).call
      end

      def find_strategy_specific_extractor(identifier)
        # Instead of loading all of ActiveSupport make an explicit declaration.
        strategy_constant_name = ActiveSupport::Inflector.classify("#{identifier.strategy}_strategy")
        const_get(strategy_constant_name).new(identifier: identifier)
      end
      private_class_method :find_strategy_specific_extractor
    end
  end
end
