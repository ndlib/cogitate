require 'active_record/base'

# Responsible for giving a name to a group of people. This is not the role
# nor responsibility that those people fill. It is an alias for a collection
# of people.
class Group < ActiveRecord::Base
  delegate :to_s, to: :name
end
