class AddingSipityGroupsForEtds < ActiveRecord::Migration
  def self.up
    graduate_school_etd_reviewers = 'Graduate School ETD Reviewers'
    Group.find_or_create_by!(name: graduate_school_etd_reviewers)
    RepositoryService::IdentifierRelationship.create!(
      left_strategy: Cogitate::Models::Identifier::GROUP_STRATEGY_NAME, left_identifying_value: graduate_school_etd_reviewers,
      right_strategy: "netid", right_identifying_value: 'shill2'
    )

    all_verified_netid_users = Cogitate::Models::Identifier.new_for_implicit_verified_group_by_strategy(strategy: 'netid')
    Group.find_or_create_by!(name: all_verified_netid_users.identifying_value)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
