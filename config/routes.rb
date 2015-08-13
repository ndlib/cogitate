Rails.application.routes.draw do
  # Look in the Api module and prefix paths with api
  namespace :api do
    # By doing this, I'm hoping to be able to cache via ETags the results
    # It does mean that you need to be mindful of escaping identifiers with / in them
    get 'agents/:urlsafe_base64_encoded_identifiers', to: 'agents#index'
  end

  get '/auth', to: 'sessions#new'
  get '/claim', to: 'sessions#show'

  get '/auth/:provider/callback', to: 'sessions#create'
  if Rails.env.test? || Rails.env.development?
    post '/auth/developer/callback', to: 'sessions#create'
  end
end
