class AddingSipityGroupsForEtds < ActiveRecord::Migration
  def self.up
    graduate_school_etd_reviewers = 'Graduate School ETD Reviewers'
    Group.find_or_create_by!(name: graduate_school_etd_reviewers)
    RepositoryService::IdentifierRelationship.create!(
      left_strategy: Group::IDENTIFIER_STRATEGY_NAME, left_identifying_value: graduate_school_etd_reviewers,
      right_strategy: "netid", right_identifying_value: 'shill2'
    )

    Group.find_or_create_by!(name: Group::ALL_VERIFIED_NETID_USERS)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
