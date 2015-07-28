require 'active_record'
module RepositoryService
  # The connection between two Identifiers. This class leverages
  # some of the convenience methods of ActiveRecord but I don't want
  # to be passing this information around, instead preferring a PORO.
  class IdentifierRelationship < ActiveRecord::Base
  end
end
