require 'spec_fast_helper'
require 'cogitate/services/ticket_to_token_coercer'

RSpec.describe Cogitate::Services::TicketToTokenCoercer do
  subject { described_class }
  its(:default_repository) { should respond_to(:find_current_identifier_for) }
  its(:default_identifier_tokenizer) { should respond_to(:call) }

  let(:identifier) { double('Identifier') }
  let(:repository) { double('Repository', find_current_identifier_for: identifier) }
  let(:identifier_tokenizer) { double('Repository', call: true) }
  let(:ticket) { '123-456' }
  context '.call' do
    it 'will coerce a token into a token' do
      expect(repository).to receive(:find_current_identifier_for).with(ticket: ticket).and_return(identifier)
      expect(identifier_tokenizer).to receive(:call).with(identifier: identifier).and_return(:the_token)
      expect(subject.call(ticket: ticket, repository: repository, identifier_tokenizer: identifier_tokenizer)).to eq(:the_token)
    end
  end
end
