require 'identifier/verified'

class Identifier
  # :nodoc:
  module Verified
    Netid = Verified.build_named_strategy('first_name', 'last_name', 'netid', 'full_name', 'ndguid', 'email')
  end
end
