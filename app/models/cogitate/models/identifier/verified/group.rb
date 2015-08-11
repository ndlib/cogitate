require 'cogitate/interfaces'
require 'cogitate/models/identifier/verified'

module Cogitate
  module Models
    class Identifier
      # :nodoc:
      module Verified
        Group = Verified.build_named_strategy('name', 'description')
      end
    end
  end
end
