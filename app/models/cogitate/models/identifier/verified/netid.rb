require 'cogitate/models/identifier/verified'
require 'active_support/core_ext/object/blank'

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

          def name
            return full_name if full_name.present?
            return "#{first_name} #{last_name}".strip if first_name.present? || last_name.present?
            netid
          end
        end
      end
    end
  end
end
