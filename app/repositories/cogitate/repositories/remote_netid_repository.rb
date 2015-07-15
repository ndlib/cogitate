require 'contracts'
require 'cogitate_interfaces'
module Cogitate
  module Repositories
    # Container for repository services against the remote netid API
    module RemoteNetidRepository
      extend Contracts
      # Given an identifier
      Contract(Contracts::KeywordArgs[identifier: Cogitate::IdentifierInterface])
      def self.find(identifier:)
      end
    end
  end
end
