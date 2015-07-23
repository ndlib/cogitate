require 'rails_helper'

describe 'api/agents', type: :routing do
  it 'routes api/agents/123 (so we can set ETags for caching)' do
    expect(get: 'api/agents/123').to route_to(
      controller: 'api/agents', action: 'index', urlsafe_base64_encoded_identifiers: '123'
    )
  end

  it 'routes api/agents/something.com' do
    expect(get: 'api/agents/something.com').to route_to(
      controller: 'api/agents', action: 'index', urlsafe_base64_encoded_identifiers: 'something', format: 'com'
    )
  end

  it 'does not route api/agents' do
    expect(get: 'api/agents').to_not be_routable
  end

  it 'does not route api/agent' do
    expect(get: 'api/agent').to_not be_routable
  end

  it 'does not route api/agent/123' do
    expect(get: 'api/agent/123').to_not be_routable
  end
end
