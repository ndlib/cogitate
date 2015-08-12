require 'rails_helper'
require 'cogitate/services/tokenizer'

RSpec.describe Cogitate::Services::Tokenizer do
  its(:default_encryption_type) { should eq(Figaro.env.cogitate_services_tokenizer_encryption_type) }
  its(:default_password) { should eq(Figaro.env.cogitate_services_tokenizer_password) }
  its(:default_issuer_claim) { should eq(Figaro.env.cogitate_services_tokenizer_issuer_claim) }

  let(:data) { { identifier: 'hello' } }
  let(:password) { nil }
  let(:encryption_type) { false }
  let(:issuer_claim) { "The Man" }

  subject { described_class.new(password: nil, encryption_type: 'none', issuer_claim: issuer_claim) }

  context '#to_token' do
    it 'will transform the agent to JSON then encode that JSON via JWT encoding' do
      expect(subject.to_token(data: data)).to be_a(String)
    end

    it 'will be decodable via the JWT module' do
      token = subject.to_token(data: data)
      decoded_token = JWT.decode(token, password, false, 'iss' => issuer_claim, verify_iss: true)
      expected_token = [{ data: data.as_json, iss: issuer_claim }.stringify_keys, { 'typ' => 'JWT', 'alg' => 'none' }]
      expect(decoded_token).to eq(expected_token)
    end

    it 'will be decodable via the JWT module with an enforceable issue' do
      token = subject.to_token(data: data)
      expect { JWT.decode(token, password, false, 'iss' => 'bogus', verify_iss: true) }.to raise_error(JWT::InvalidIssuerError)
    end
  end

  context 'to token then from token' do
    it 'will transform the agent to JSON then encode that JSON via JWT encoding' do
      token = described_class.to_token(data: data, password: Figaro.env.cogitate_services_tokenizer_private_password!)
      expect(
        described_class.from_token(token: token, password: Figaro.env.cogitate_services_tokenizer_public_password!).fetch('identifier')
      ).to eq(data.fetch(:identifier))
    end
    it 'will raise an issuer error if issuer does not match' do
      token = described_class.to_token(data: data, issuer_claim: 'The Woman')
      expect { described_class.from_token(token: token, issuer_claim: 'The Man') }.to raise_error(JWT::InvalidIssuerError)
    end
  end

  context '#from_token' do
    it 'will raise an exception if improperly encoded' do
      token = subject.to_token(data: data)
      expect { subject.from_token(token: "2#{token}2") }.to raise_error(JWT::DecodeError)
    end
  end

  context '.from_token' do
    subject { described_class }
    it { should respond_to(:from_token) }
  end

  context '.to_token' do
    subject { described_class }
    it { should respond_to(:to_token) }
  end
end
