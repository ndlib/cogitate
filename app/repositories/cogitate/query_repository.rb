require 'cogitate/models/identifier'
require 'cogitate/models/identifiers/verified/group'

module Cogitate
  # A class that is responsible for querying persistence layers and returning a business object.
  class QueryRepository
    # @api private
    # TODO: Given that this repository could be multi-purpose, is it better to pass the collaborator
    #       as a parameter to the method that would use it?
    # @param identifier_relationship_repository [#each_identifier_related_to]
    def initialize(identifier_relationship_repository: default_identifier_relationship_repository)
      self.identifier_relationship_repository = identifier_relationship_repository
    end

    # @api public
    #
    # Responsible for exposing a means of iteration on verified groups related to the given identifier
    #
    # @param identifier [Cogitate::Interfaces::Identifier]
    def with_verified_group_identifier_related_to(identifier:)
      return enum_for(:with_verified_group_identifier_related_to, identifier: identifier) unless block_given?
      each_identifier_related_to(identifier: identifier, strategy: Models::Identifier::GROUP_STRATEGY_NAME) do |group_identifier|
        with_verified_existing_group_for(identifier: group_identifier) { |verified_group| yield(verified_group) }
      end
      :with_verified_group_identifier_related_to
    end

    # @api publid
    #
    # If you provide an identifier that is an existing group it will yield the verified group identifier. Otherwise it will not yield.
    #
    # @yieldparam verified_identifier [Models::Identifiers::Verified::Group]
    # @param identifier [Cogitate::Interfaces::Identifier]
    def with_verified_existing_group_for(identifier:)
      return enum_for(:with_verified_existing_group_for, identifier: identifier) unless block_given?
      return unless identifier.strategy == Models::Identifier::GROUP_STRATEGY_NAME
      group = Group.find_by(identifying_value: identifier.identifying_value)
      return if group.nil?
      yield(
        Models::Identifiers::Verified::Group.new(identifier: identifier, attributes: { name: group.name, description: group.description })
      )
    end

    extend Forwardable
    def_delegator :identifier_relationship_repository, :each_identifier_related_to

    private

    attr_accessor :identifier_relationship_repository

    # @api private
    def default_identifier_relationship_repository
      require 'repository_service/identifier_relationship' unless defined?(RepositoryService::IdentifierRelationship)
      RepositoryService::IdentifierRelationship
    end
  end
end
