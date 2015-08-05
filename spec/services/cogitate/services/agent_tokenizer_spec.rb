require 'rails_helper'
require 'cogitate/services/agent_tokenizer'
require 'jwt'

module Cogitate
  module Services
    RSpec.describe AgentTokenizer do
      let(:agent) { { identifier: 'hello' } }
      let(:password) { nil }
      let(:encryption_type) { false }
      let(:issuer_claim) { "The Man" }
      subject { described_class.new(agent: agent, password: nil, encryption_type: 'none', issuer_claim: issuer_claim) }

      its(:default_encryption_type) { should eq(Figaro.env.agent_tokenizer_encryption_type) }
      its(:default_password) { should eq(Figaro.env.agent_tokenizer_private_password) }

      it 'exposes .call as a convenience method' do
        expect_any_instance_of(described_class).to receive(:call)
        described_class.call(agent: agent, password: nil, encryption_type: 'none', issuer_claim: issuer_claim)
      end

      context '#call' do
        it 'will transform the agent to JSON then encode that JSON via JWT encoding' do
          expect(subject.call).to be_a(String)
        end

        it 'will use the default password even though it must first be coerced' do
          subject = described_class.new(agent: agent)
          expect(subject.call).to be_a(String)
        end

        it 'will be decodable via the JWT module' do
          token = subject.call
          decoded_token = JWT.decode(token, password, false, 'iss' => issuer_claim, verify_iss: true)
          expected_token = [subject.send(:payload).stringify_keys, { 'typ' => 'JWT', 'alg' => 'none' }]
          expect(decoded_token).to eq(expected_token)
        end

        it 'will be decodable via the JWT module with an enforceable issue' do
          token = subject.call
          expect { JWT.decode(token, password, false, 'iss' => 'bogus', verify_iss: true) }.to raise_error(JWT::InvalidIssuerError)
        end
      end

      # While it may be odd to test a private method, I want to make sure that its under test regarding its contents.
      context '#payload' do
        let(:payload) { subject.send(:payload) }
        it 'will have a :data key that is a representation of the agent' do
          expect(payload.fetch(:data)).to eq(agent.as_json)
        end
        it 'will have :data and :iss keys' do
          expect(payload.keys).to eq([:data, :iss])
        end
      end
    end
  end
end
