Rails.application.routes.draw do
  # Look in the Api module and prefix paths with api
  namespace :api do
    # By doing this, I'm hoping to be able to cache via ETags the results
    # It does mean that you need to be mindful of escaping identifiers with / in them
    get 'identifiers/:urlsafe_base64_encoded_identifiers', to: 'identifiers#index'
  end
end
