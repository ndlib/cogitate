require 'active_record'
require 'cogitate/interfaces'
require 'identifier'

module RepositoryService
  # The connection between two Identifiers. This class leverages
  # some of the convenience methods of ActiveRecord but I don't want
  # to be passing this information around, instead preferring a PORO.
  class IdentifierRelationship < ActiveRecord::Base
    self.table_name = 'repository_service_identifier_relationships'
    # Responsible for finding related identifiers by checking both "sides" (i.e. left and right) of the relationship.
    #
    # @api public
    # @param identifier [Identifier]
    # @param strategy [String, nil] Limit the relationship to objects of the given strategy; If none is given there are no limits.
    # @return If a block is given, it will yield each identifier. Otherwise an Enumerator is returned (and you can use #each on
    #         that Enumerator).
    # @note This method violates Assignment Branch Condition complexity but I feel this is an acceptable compromise given
    #       that the other option is extracting two private methods and passing a lambda into each of those
    def self.each_identifier_related_to(identifier:, strategy: nil)
      return enum_for(:each_identifier_related_to, identifier: identifier, strategy: strategy) unless block_given?
      each_right_identifier_related_to(identifier: identifier, strategy: strategy) { |related_identifier| yield(related_identifier) }
      each_left_identifier_related_to(identifier: identifier, strategy: strategy) { |related_identifier| yield(related_identifier) }
      nil
    end

    # @api private
    def self.each_left_identifier_related_to(identifier:, strategy: nil)
      scope = strategy.nil? ? self : where(left_strategy: strategy)
      scope.where(right_strategy: identifier.strategy, right_identifying_value: identifier.identifying_value).find_each do |relationship|
        yield(Identifier.new(strategy: relationship.left_strategy, identifying_value: relationship.left_identifying_value))
      end
    end

    # @api private
    def self.each_right_identifier_related_to(identifier:, strategy: nil)
      scope = strategy.nil? ? self : where(right_strategy: strategy)
      scope.where(left_strategy: identifier.strategy, left_identifying_value: identifier.identifying_value).find_each do |relationship|
        yield(Identifier.new(strategy: relationship.right_strategy, identifying_value: relationship.right_identifying_value))
      end
    end
    private_class_method :each_left_identifier_related_to, :each_right_identifier_related_to
  end
end
