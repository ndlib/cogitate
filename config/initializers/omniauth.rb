OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.test? || Rails.env.development?
  provider :cas, url: Figaro.env.omniauth_cas_url!
end
