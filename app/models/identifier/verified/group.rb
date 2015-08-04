require 'cogitate/interfaces'
require 'identifier/verified'

class Identifier
  # :nodoc:
  module Verified
    Group = Verified.build_named_strategy('name', 'description')
  end
end
