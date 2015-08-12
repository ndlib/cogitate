require 'cogitate/models/identifier/verified'

module Cogitate
  module Models
    class Identifier
      # :nodoc:
      module Verified
        Netid = Verified.build_named_strategy('first_name', 'last_name', 'netid', 'full_name', 'ndguid', 'email') do
          # Making an assumption that all NetID's can send an email to netid@nd.edu
          # It also appears that 'email' from the API server is coming back as blank
          def email
            "#{netid}@nd.edu"
          end
        end
      end
    end
  end
end
