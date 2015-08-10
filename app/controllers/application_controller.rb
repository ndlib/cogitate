require 'cogitate/interfaces'
# The base controller for Cogitate
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def signed_in?
    !!current_user
  end

  include Contracts
  Contract(None => Or[Cogitate::Interfaces::IdentifierInterface, Eq[false]])
  def current_user
    @current_user ||=
    if session.key?(:user_identifying_value) && session.key?(:user_strategy)
      Cogitate::Models::Identifier.new(strategy: session.fetch(:user_strategy), identifying_value: session.fetch(:user_identifying_value))
    else
      false
    end
  end

  Contract(Cogitate::Interfaces::IdentifierInterface => Any)
  def current_user=(identifier)
    @current_user = identifier
    # The session does not allow nested hashes, so I'm breaking it apart
    session[:user_strategy] = identifier.strategy
    session[:user_identifying_value] = identifier.identifying_value
    @current_user
  end

  helper_method :signed_in?, :current_user
end
