require 'rails_helper'

describe 'api/identifiers', type: :routing do
  it 'routes api/identifiers/123 (so we can set ETags for caching)' do
    expect(get: 'api/identifiers/123').to route_to(
      controller: 'api/identifiers', action: 'index', urlsafe_base64_encoded_identifiers: '123'
    )
  end

  it 'routes api/identifiers/something.com' do
    expect(get: 'api/identifiers/something.com').to route_to(
      controller: 'api/identifiers', action: 'index', urlsafe_base64_encoded_identifiers: 'something', format: 'com'
    )
  end

  it 'does not route api/identifiers' do
    expect(get: 'api/identifiers').to_not be_routable
  end

  it 'does not route api/identifier' do
    expect(get: 'api/identifier').to_not be_routable
  end

  it 'does not route api/identifier/123' do
    expect(get: 'api/identifier/123').to_not be_routable
  end
end
