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
end
