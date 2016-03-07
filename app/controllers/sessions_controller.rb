require "cogitate/models/identifier"
require 'cogitate/services/uri_safe_ticket_for_identifier_creator'
require 'cogitate/services/ticket_to_token_coercer'

# Responsible for negotiating session authentication
class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL = :after_authentication_callback_url
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
    set_current_user!
    after_authentication_callback_url = session[QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL]
    if after_authentication_callback_url
      ticket = Cogitate::Services::UriSafeTicketForIdentifierCreator.call(identifier: current_user)
      redirect_to "#{after_authentication_callback_url}?ticket=#{ticket}"
    else
      redirect_to "/api/agents/#{current_user.encoded_id}"
    end
  end

  def show
    token = Cogitate::Services::TicketToTokenCoercer.call(ticket: params.fetch(:ticket))
    render text: token, format: 'text/plain'
  end

  private

  def set_current_user!
    self.current_user = Cogitate::Models::Identifier.new(strategy: strategy, identifying_value: identifying_value)
  end

  def identifying_value
    auth_hash.fetch('uid')
  end

  PROVIDER_TO_STRATEGY = { 'cas' => 'netid', 'developer' => 'email' }.freeze
  def strategy
    # Because the provider may be a symbol
    provider = auth_hash.fetch('provider').to_s
    PROVIDER_TO_STRATEGY.fetch(provider, provider)
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  # @api private
  class NewActionConstraintHandler
    REGEXP_VALIDATOR_OF_AFTER_AUTHENTICATION_CALLBACK_URL = (Rails.env.development? ? %r{^https?://} : %r{^https://}).freeze

    def initialize(controller:, query_key: SessionsController::QUERY_KEY_FOR_AFTER_AUTHENTICATION_CALLBACK_URL)
      self.controller = controller
      self.query_key = query_key
      set_after_authentication_callback_url!
    end

    def valid?
      return false if @after_authentication_callback_url.blank?
      return false if @after_authentication_callback_url !~ REGEXP_VALIDATOR_OF_AFTER_AUTHENTICATION_CALLBACK_URL
      true
    end

    def after_authentication_callback_url
      return @after_authentication_callback_url if valid?
      raise "#{@after_authentication_callback_url.inspect} is not a valid URL for an after authentication callback"
    end

    private

    def set_after_authentication_callback_url!
      @after_authentication_callback_url = CGI.unescape(controller.params.fetch(query_key, ''))
    end

    attr_accessor :controller, :query_key
  end
end
