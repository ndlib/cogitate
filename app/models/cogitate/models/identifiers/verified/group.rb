require 'cogitate/interfaces'
require 'cogitate/models/identifiers/verified'

module Cogitate
  module Models
    module Identifiers
      # :nodoc:
      module Verified
        Group = Verified.build_named_strategy('name', 'description')
      end
    end
  end
end
