require 'active_record/base'

# Responsible for giving a name to a group of people. This is not the role
# nor responsibility that those people fill. It is an alias for a collection
# of people.
class Group < ActiveRecord::Base
  ALL_VERIFIED_NETID_USERS = 'All Verified "netid" Users'.freeze
  IDENTIFIER_STRATEGY_NAME = 'group'.freeze
  self.primary_key = :id
  delegate :to_s, to: :name
end
