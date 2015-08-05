require 'rails_helper'
require 'identifier'

RSpec.describe SessionsController do
  context 'GET #new' do
    let(:the_after_authentication_callback_url) { 'http://google.com' }

    it "will return a 403 (Forbidden) when handling an invalid request" do
      allow_any_instance_of(described_class::NewActionConstraintHandler).to receive(:valid?).and_return(false)
      get :new, after_authentication_callback_url:  CGI.escape(the_after_authentication_callback_url)
      expect(response).to have_http_status(403)
      expect(response.body).to eq(described_class::FORBIDDEN_TEXT_FOR_NEW)
    end

    it "will redirect to the /auth/cas route and store the after_authentication_callback_url" do
      allow_any_instance_of(described_class::NewActionConstraintHandler).to receive(:valid?).and_return(true)
      get :new, after_authentication_callback_url: CGI.escape(the_after_authentication_callback_url)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/auth/cas')
      expect(controller.session[:after_authentication_callback_url]).to eq(the_after_authentication_callback_url)
    end
  end
  context 'GET #create' do
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

class SessionsController
  RSpec.describe NewActionConstraintHandler do
    [
      { params: { after_authentication_callback_url: 'https://google.com' }, valid?: true, callback_url: 'https://google.com' },
      { params: { after_authentication_callback_url: CGI.escape('https://google.com') }, valid?: true, callback_url: 'https://google.com' },
      { params: { after_authentication_callback_url: '/hello' }, valid?: false, callback_url: RuntimeError },
      { params: { after_authentication_callback_url: '' }, valid?: false, callback_url: RuntimeError },
      { params: { after_authentication_callback_url: CGI.escape('http://google.com') }, valid?: false, callback_url: RuntimeError },
      { params: {}, valid?: false, callback_url: RuntimeError }
    ].each do |test_case|
      it "will have #valid? == #{test_case.fetch(:valid?)} for params #{test_case.fetch(:params).inspect}" do
        controller = double(params: test_case.fetch(:params))
        subject = described_class.new(controller: controller)
        expect(subject.valid?).to eq(test_case.fetch(:valid?))
      end

      it "will have an after_authentication_callback_url of #{test_case[:callback_url].inspect} for params #{test_case[:params].inspect}" do
        controller = double(params: test_case.fetch(:params))
        subject = described_class.new(controller: controller)
        expected_response = test_case.fetch(:callback_url)
        if expected_response == RuntimeError
          expect { subject.after_authentication_callback_url }.to raise_error(expected_response)
        else
          expect(subject.after_authentication_callback_url).to eq(expected_response)
        end
      end
    end
  end
end
