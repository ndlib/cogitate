# A weird little module that requires some explanation. Given that the
# Netid identifier is not persisted in a relational way, I need a set
# of services that don't reify a traditional Rails model. Instead I will
# load the persisted data from the database and make use of a simple
# Rails ActiveRecord object to then populate a PORO data structure. This
# cleaves closer to the DataMapper pattern; One that I'm curious about but
# not yet leveraging to its fullest extent.
module RepositoryService
  def self.table_name_prefix
    'repository_service_'
  end
end
