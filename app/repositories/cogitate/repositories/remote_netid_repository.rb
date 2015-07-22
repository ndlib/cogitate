require 'contracts'
require 'cogitate/interfaces'
require 'open-uri'
require 'json'
require 'figaro'
require 'identifier/verified'
require 'identifier/unverified'

module Cogitate
  module Repositories
    # Container for repository services against the remote netid API
    module RemoteNetidRepository
      extend Contracts
      Contract(
        Contracts::KeywordArgs[
          identifier: Cogitate::Interfaces::IdentifierInterface,
          query_service: Contracts::Optional[Contracts::RespondTo[:call]]
        ] => Cogitate::Interfaces::VerifiableIdentifierInterface
      )
      def self.find(identifier:, query_service: default_query_service)
        attributes = query_service.call(identifier.identifying_value)
        if attributes.present?
          Identifier::Verified::Netid.new(identifier: identifier, attributes: attributes)
        else
          Identifier::Unverified.new(identifier: identifier)
        end
      end

      def self.default_query_service
        NetidQueryService
      end
      private_class_method :default_query_service

      # Responsible for querying the remote NetID service.
      class NetidQueryService
        include Contracts
        Contract(String => Hash)
        def self.call(identifying_value)
          new(identifying_value).to_hash
        end

        def initialize(netid)
          self.netid = netid
        end

        attr_reader :netid

        def to_hash
          parsed_response
        end

        private

        def netid=(input)
          @netid = input.to_s.strip
        end

        public

        # @return [netid] if the input is not a valid NetID
        # @return [String] if the input is a valid NetID
        def preferred_name
          parsed_response.fetch('full_name')
        rescue KeyError
          netid
        end

        # @return [false] if the input is not a valid NetID
        # @return [String] if the input is a valid NetID
        def valid_netid?
          parsed_response.fetch('netid')
        rescue KeyError
          false
        end

        private

        def parsed_response
          @parsed_response ||= begin
            return {} if netid.length == 0
            parse
          rescue OpenURI::HTTPError
            {}
          end
        end

        def response
          # Leveraging 'open-uri' and its easy to use interface
          open(url).read
        end

        def parse
          JSON.parse(response).fetch('people').first
        end

        def url
          base_uri = URI.parse(Figaro.env.hesburgh_api_host!)
          base_uri.path = "/1.0/people/by_netid/#{netid}.json"
          base_uri.query = "auth_token=#{Figaro.env.hesburgh_api_auth_token!}"
          base_uri.to_s
        end
      end
      private_constant :NetidQueryService
    end
  end
end
