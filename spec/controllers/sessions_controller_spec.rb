require 'rails_helper'
require 'identifier'

RSpec.describe SessionsController do
  context '#create' do
    context 'with valid data' do
      let(:identifier) { Identifier.new(strategy: 'email', identifying_value: 'jfriesen') }
      it 'will assign the current user' do
        controller.request.env['omniauth.auth'] = { 'uid' => identifier.base_identifying_value, 'provider' => identifier.base_strategy }
        get :create
        expect(controller.send(:current_user)).to eq(identifier)
      end
    end
  end
end
