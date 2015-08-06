require 'identifier/verified'

class Identifier
  # :nodoc:
  module Verified
    Netid = Verified.build_named_strategy('first_name', 'last_name', 'netid', 'full_name', 'ndguid', 'email') do
      def email
        "#{netid}@nd.edu"
      end
    end
  end
end
