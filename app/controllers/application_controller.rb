require 'cogitate/interfaces'
require 'cogitate/models/identifier'
# The base controller for Cogitate
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def signed_in?
    !!current_user
  end

  include Contracts
  Contract(None => Or[Cogitate::Interfaces::IdentifierInterface, Eq[false]])
  # @api public
  # @todo Is there a concept of a NullIdentifier instead of a `false` value
  def current_user
    @current_user ||=
    if session.key?(:user_identifying_value) && session.key?(:user_strategy)
      # Switched from `session.fetch(:user_strategy)` to `session[:user_strategy]` as per https://github.com/rails/rails/issues/21383
      Cogitate::Models::Identifier.new(strategy: session[:user_strategy], identifying_value: session[:user_identifying_value])
    else
      false
    end
  end

  Contract(Cogitate::Interfaces::IdentifierInterface => Any)
  # @api public
  def current_user=(identifier)
    @current_user = identifier
    # The session does not allow nested hashes, so I'm breaking it apart
    session[:user_strategy] = identifier.strategy
    session[:user_identifying_value] = identifier.identifying_value
    @current_user
  end

  helper_method :signed_in?, :current_user
end
