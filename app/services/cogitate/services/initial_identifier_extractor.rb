require 'contracts'
require 'cogitate/interfaces'
require 'active_support/inflector/methods'
require 'cogitate/services/initial_identifier_extractor/parroting_strategy'

module Cogitate
  module Services
    # Responsible for handling the initial identifier extraction
    # @see .call for more details
    module InitialIdentifierExtractor
      extend Contracts

      Contract(
        Contracts::KeywordArgs[
          identifier: Cogitate::Interfaces::IdentifierInterface, visitor: Cogitate::Interfaces::VisitorInterface,
          visitation_type: Contracts::Optional[Symbol], membership_visitation_finder: Contracts::Optional[Contracts::RespondTo[:call]]
        ] => Contracts::Any
      )
      # @todo Refine what the expected return value is
      def self.call(identifier:, visitor:, visitation_type: :first, **keywords)
        host = identifying_host_for(identifier: identifier, visitation_type: visitation_type, **keywords)
        host.invite(visitor)
      end

      Contract(
        Contracts::KeywordArgs[
          identifier: Cogitate::Interfaces::IdentifierInterface, visitation_type: Symbol,
          membership_visitation_finder: Contracts::Optional[Contracts::RespondTo[:call]]
        ] =>
        Cogitate::Interfaces::HostInterface
      )
      # @api public
      # @todo What is the constant missing behavior?
      def self.identifying_host_for(identifier:, visitation_type:, membership_visitation_finder: default_membership_visitation_finder)
        hosting_strategy = find_hosting_strategy(identifier: identifier)
        membership_visitation_service = membership_visitation_finder.call(identifier: identifier, visitation_type: visitation_type)
        hosting_strategy.call(identifier: identifier, membership_visitation_service: membership_visitation_service)
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

      def self.default_membership_visitation_finder
        require 'cogitate/services/membership_visitation_strategy' unless defined?(Services::MembershipVisitationStrategy)
        Services::MembershipVisitationStrategy.method(:find)
      end
      private_class_method :default_membership_visitation_finder
    end
  end
end
