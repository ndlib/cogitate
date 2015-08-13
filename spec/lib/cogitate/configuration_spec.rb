require 'cogitate/configuration'

RSpec.describe Cogitate::Configuration do
  subject { described_class.new }
  context '#remote_server_base_url' do
    it 'will use the set value' do
      subject.remote_server_base_url = 'hello'
      expect(subject.remote_server_base_url).to eq('hello')
    end
    it 'will raise an exception if not set' do
      expect { subject.remote_server_base_url }.to raise_error(described_class::ConfigurationError)
    end
  end
  context '#tokenizer_password' do
    it 'will use the set value' do
      subject.tokenizer_password = 'hello'
      expect(subject.tokenizer_password).to eq('hello')
    end
    it 'will raise an exception if not set' do
      expect { subject.tokenizer_password }.to raise_error(described_class::ConfigurationError)
    end
  end
  context '#tokenizer_encryption_type' do
    it 'will use the set value' do
      subject.tokenizer_encryption_type = 'hello'
      expect(subject.tokenizer_encryption_type).to eq('hello')
    end
    it 'will raise an exception if not set' do
      expect { subject.tokenizer_encryption_type }.to raise_error(described_class::ConfigurationError)
    end
  end
  context '#tokenizer_issuer_claim' do
    it 'will use the set value' do
      subject.tokenizer_issuer_claim = 'hello'
      expect(subject.tokenizer_issuer_claim).to eq('hello')
    end
    it 'will raise an exception if not set' do
      expect { subject.tokenizer_issuer_claim }.to raise_error(described_class::ConfigurationError)
    end
  end
end
