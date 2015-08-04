require 'identifier'

# Responsible for negotiating session authentication
class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # @todo All callbacks point to this single action. Is that the correct behavior?
  def create
    self.current_user = Identifier.new(strategy: strategy, identifying_value: identifying_value)
    redirect_to "/api/agents/#{current_user.encoded_id}"
  end

  private

  def identifying_value
    auth_hash.fetch('uid')
  end

  PROVIDER_TO_STRATEGY = { 'cas' => 'netid', 'developer' => 'email' }.freeze
  def strategy
    provider = auth_hash.fetch('provider')
    PROVIDER_TO_STRATEGY.fetch(provider, provider)
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
