module Api
  # The controller to handle an identifiers request
  class AgentsController < ApplicationController
    before_action :force_json_format # This is the quickest mechanism to force API structure

    # Responsible for rendering an array of Agents
    #
    # @api public
    # @see Cogitate::Services::EncodedIdentifiersToAgentsMapper
    def index
      return unless stale_encoded_identifiers?
      @agents = Cogitate::Services::EncodedIdentifiersToAgentsMapper.call(encoded_identifiers: encoded_identifiers)
      render content_type: 'application/vnd.api+json'
    end

    private

    # @api private
    def force_json_format
      request.format = :json
    end

    # @note I'm assuming that the underlying data is not exceptionally volatile.
    #       Given the nature of what is being built, I'm going to consider a caching mechanism for each identifier.
    #       However that caching mechanism is not at the HTTP level but is instead at a memory level.
    #
    # @api private
    def stale_encoded_identifiers?
      stale?(etag: encoded_identifiers, last_modified: encoded_identifiers_last_modified)
    end

    # @api private
    def encoded_identifiers
      params.fetch(:urlsafe_base64_encoded_identifiers)
    end

    # @api private
    # @note This is an assumption that changes are very low in frequency
    def encoded_identifiers_last_modified
      3.minutes.ago
    end
  end
end
