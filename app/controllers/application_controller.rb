# The base controller for Cogitate
class ApplicationController < ActionController::API
  def self.protect_from_forgery(*)
  end
  protect_from_forgery with: :null_session
end
