require 'identifier'

# Responsible for negotiating session authentication
class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL =  :after_authentication_callback_url
  FORBIDDEN_TEXT_FOR_NEW = "FORBIDDEN: Expected query parameter 'after_authentication_callback_url' to be a CGI escaped Secure URL".freeze

  # @api public
  #
  # This action is the external API end point for brokered authentication via Cogitate.
  # It is responsible for ensuring a well-formed brokerable request and remembering relevant after authentication information.
  #
  # @todo For now, Cogitate is making the decision that all authentication happens via CAS
  #    Eventually we may introduce a point for a human to make a decision.
  def new
    contraint_handler = NewActionConstraintHandler.new(controller: self, query_key: QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL)
    if contraint_handler.valid?
      session[QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL] = contraint_handler.after_authentication_callback_url
      redirect_to '/auth/cas'
    else
      render text: FORBIDDEN_TEXT_FOR_NEW, status: :forbidden
    end
  end

  # @todo All callbacks point to this single action. Is that the correct behavior?
  def create
    self.current_user = Identifier.new(strategy: strategy, identifying_value: identifying_value)
    # Generate the Agent token for this identifier
    # Redirect back to the after_authenticate URL that is stored in the session
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

  # @api private
  class NewActionConstraintHandler
    def initialize(controller:, query_key: SessionsController::QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL)
      self.controller = controller
      self.query_key = query_key
      set_after_authentication_callback_url!
    end

    def valid?
      return false if @after_authentication_callback_url.blank?
      return false if @after_authentication_callback_url !~ %r{^https://}
      true
    end

    def after_authentication_callback_url
      return @after_authentication_callback_url if valid?
      fail "#{@after_authentication_callback_url.inspect} is not a valid URL for an after authentication callback"
    end

    private

    def set_after_authentication_callback_url!
      @after_authentication_callback_url = CGI.unescape(controller.params.fetch(query_key, ''))
    end

    attr_accessor :controller, :query_key
  end
end
