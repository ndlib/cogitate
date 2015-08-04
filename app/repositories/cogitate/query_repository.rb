require 'identifier/verified/group'

module Cogitate
  # A class that is responsible for querying persistence layers and returning a business object.
  class QueryRepository
    GROUP_STRATEGY = 'group'.freeze

    # TODO: Given that this repository could be multi-purpose, is it better to pass the collaborator
    #       as a parameter to the method that would use it?
    def initialize(identifier_relationship_repository: default_identifier_relationship_repository)
      self.identifier_relationship_repository = identifier_relationship_repository
    end

    # @api public
    def with_verified_group_identifier_related_to(identifier:)
      return enum_for(:with_verified_group_identifier_related_to, identifier: identifier) unless block_given?
      identifier_relationship_repository.each_identifier_related_to(identifier: identifier, strategy: GROUP_STRATEGY) do |group_identifier|
        with_verified_existing_group_for(identifier: group_identifier) { |verified_group| yield(verified_group) }
      end
      :with_verified_group_identifier_related_to
    end

    # @api private I'm not yet certain if I should yield a group for which we have no record or if I can yield a stub of information
    def with_verified_existing_group_for(identifier:)
      return enum_for(:with_verified_existing_group_for, identifier: identifier) unless block_given?
      group = Group.find_by(id: identifier.identifying_value)
      return if group.nil?
      yield(Identifier::Verified::Group.new(identifier: identifier, attributes: { name: group.name, description: group.description }))
    end

    private

    attr_accessor :identifier_relationship_repository

    def default_identifier_relationship_repository
      require 'repository_service/identifier_relationship'
      RepositoryService::IdentifierRelationship
    end
  end
end
