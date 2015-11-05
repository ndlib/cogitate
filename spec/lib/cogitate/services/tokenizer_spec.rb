require 'rails_helper'
require 'cogitate/services/tokenizer'
require 'cogitate/configuration'

RSpec.describe Cogitate::Services::Tokenizer do
  let(:data) { { 'identifier' => 'hello' } }
  let(:password) { nil }
  let(:encryption_type) { false }
  let(:issuer_claim) { "The Man" }
  let(:configuration) do
    Cogitate::Configuration.new(tokenizer_password: nil, tokenizer_encryption_type: 'none', tokenizer_issuer_claim: issuer_claim)
  end

  its(:default_configuration) { should be_a(Cogitate::Configuration) }
  subject { described_class.new(configuration: configuration) }

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
      expect { JWT.decode(token, password, false, iss: 'bogus', verify_iss: true) }.to raise_error(JWT::InvalidIssuerError)
    end
  end

  context 'to token then from token' do
    it 'will transform the agent to JSON then encode that JSON via JWT encoding' do
      from_token_config = Cogitate::Configuration.new(
        tokenizer_password: Figaro.env.cogitate_services_tokenizer_public_password!,
        tokenizer_encryption_type: Figaro.env.cogitate_services_tokenizer_encryption_type!,
        tokenizer_issuer_claim: Figaro.env.cogitate_services_tokenizer_issuer_claim!
      )
      from_data_config = Cogitate::Configuration.new(
        tokenizer_password: Figaro.env.cogitate_services_tokenizer_private_password!,
        tokenizer_encryption_type: Figaro.env.cogitate_services_tokenizer_encryption_type!,
        tokenizer_issuer_claim: Figaro.env.cogitate_services_tokenizer_issuer_claim!
      )
      token = described_class.to_token(data: data, configuration: from_data_config)
      expect(described_class.from_token(token: token, configuration: from_token_config)).to eq(data)
    end
    it 'will raise an issuer error if issuer does not match' do
      token_config = Cogitate::Configuration.new(tokenizer_password: nil, tokenizer_encryption_type: 'none', tokenizer_issuer_claim: 'A')
      data_config = Cogitate::Configuration.new(tokenizer_password: nil, tokenizer_encryption_type: 'none', tokenizer_issuer_claim: 'B')
      token = described_class.to_token(data: data, configuration: data_config)
      expect { described_class.from_token(token: token, configuration: token_config) }.to raise_error(JWT::InvalidIssuerError)
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
