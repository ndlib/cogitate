require 'rails_helper'

RSpec.describe ApplicationController do
  let(:identifier) { Identifier.new(strategy: 'email', identifying_value: 'hello@world.com') }
  context '#current_user=' do
    it 'will set the session based on the input' do
      expect { controller.send(:current_user=, identifier) }.to(
        change { controller.session.keys }.from([]).to(['user_strategy', 'user_identifying_value'])
      )
    end

    it 'will set an instance variable' do
      expect { controller.send(:current_user=, identifier) }.to(
        change { controller.instance_variable_get(:@current_user) }.from(nil).to(identifier)
      )
    end
  end

  context '#current_user' do
    it 'will reconstitute an identifier from the session' do
      controller.session[:user_strategy] = identifier.base_strategy
      controller.session[:user_identifying_value] = identifier.base_identifying_value
      expect(controller.send(:current_user)).to eq(identifier)
    end

    it 'will be false if no session information is set' do
      expect(controller.send(:current_user)).to eq(false)
    end

    it 'will reuse the instance variable' do
      controller.instance_variable_set(:@current_user, identifier)
      expect(controller.send(:current_user)).to eq(identifier)
    end
  end

  context '#signed_in?' do
    it 'will be true if @current_user is an Identifier' do
      controller.instance_variable_set(:@current_user, identifier)
      expect(controller.send(:signed_in?)).to eq(true)
    end

    it 'will be false if @current_user is false' do
      expect(controller.send(:signed_in?)).to eq(false)
    end
  end
end
