require 'cogitate/configuration'

RSpec.describe Cogitate::Configuration do
  subject { described_class.new }
  described_class::CONFIG_ATTRIBUTE_NAMES.each do |method_name|
    context "##{method_name}" do
      it 'will use the set value' do
        subject.public_send("#{method_name}=", 'hello')
        expect(subject.public_send(method_name)).to eq('hello')
      end
      it 'will raise an exception if not set' do
        expect { subject.public_send(method_name) }.to raise_error(described_class::ConfigurationError)
      end
    end
  end

  context '#url_for_authentication' do
    subject do
      described_class.new(
        remote_server_base_url: 'http://google.com', after_authentication_callback_url: 'https://somewhere.com/after_authentication'
      )
    end
    its(:url_for_authentication) do
      should eq("http://google.com/auth?after_authentication_callback_url=#{CGI.escape(subject.after_authentication_callback_url)}")
    end
  end
end
