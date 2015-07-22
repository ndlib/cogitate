require 'rails_helper'
require 'base64'
require 'cogitate/interfaces'

module Api
  RSpec.describe IdentifiersController, type: :controller do
    context 'GET :index' do
      let(:encoded_identifiers) { Base64.urlsafe_encode64("ketchup\tsauce") }

      include Cogitate::RSpecMatchers
      it 'will render a json object' do
        get :index, urlsafe_base64_encoded_identifiers: encoded_identifiers
        expect(response).to be_successful
        expect(assigns(:agents)).to contractually_honor(Cogitate::Interfaces::AgentCollectionInterface)
      end
    end
  end
end
