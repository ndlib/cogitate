require 'rails_helper'

describe 'authentication routing', type: :routing do
  it 'will route GET /auth' do
    expect(get: '/authenticate').to route_to(controller: 'sessions', action: 'new')
  end
  it 'will route GET /claim' do
    expect(get: '/claim').to route_to(controller: 'sessions', action: 'show')
  end
end
