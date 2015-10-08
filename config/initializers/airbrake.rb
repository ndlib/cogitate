Airbrake.configure do |config|
  config.api_key = Figaro.env.airbrake_api_key
  config.host = Figaro.env.airbrake_host
  config.port    = 443
  config.secure  = config.port == 443
  config.user_attributes = [:id, :username]
  config.ignore << "Sipity::Exceptions::AuthorizationFailureError"
end
