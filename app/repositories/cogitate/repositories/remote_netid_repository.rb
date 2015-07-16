require 'contracts'
require 'cogitate/interfaces'
require 'authentication_vector/netid_vector'
require 'open-uri'
require 'json'

module Cogitate
  module Repositories
    # Container for repository services against the remote netid API
    module RemoteNetidRepository
      extend Contracts
      # Given an identifier
      Contract(
        Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] =>
        Cogitate::Interfaces::AuthenticationVectorNetidInterface
      )
      def self.find(identifier:)
        response_hash = query_service(identifier.identifying_value).to_hash
        AuthenticationVector::NetidVector.new(response_hash)
      end

      # @todo This should be a configuration option for the application
      Contract(String => Contracts::RespondTo[:to_hash])
      def self.query_service(identifying_value)
        NetidQueryService.new(identifying_value)
      end
      private_class_method :query_service

      # Responsible for querying the remote NetID service.
      class NetidQueryService
        def initialize(netid)
          self.netid = netid
        end

        attr_reader :netid

        def to_hash
          person
        end

        private

        def netid=(input)
          @netid = input.to_s.strip
        end

        public

        # @return [netid] if the input is not a valid NetID
        # @return [String] if the input is a valid NetID
        def preferred_name
          person.fetch('full_name')
        rescue KeyError
          netid
        end

        # @return [false] if the input is not a valid NetID
        # @return [String] if the input is a valid NetID
        def valid_netid?
          person.fetch('netid')
        rescue KeyError
          false
        end

        private

        def person
          return {} if netid.length == 0
          parse
        rescue OpenURI::HTTPError
          {}
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
