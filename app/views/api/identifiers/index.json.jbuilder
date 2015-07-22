json.links do
  json.self request.url
end

json.data(@agents) do |agent|
  json.type 'agents' # TODO: This should be the identifier strategy
  json.id agent.object_id # TODO: This should be the identifying_value
  json.relationships do
    json.identities(agent.identities) do |identity|
      json.type identity.strategy
      json.id identity.identifying_value
      json.attributes do
        json.(identity, *identity.attribute_keys)
      end
    end

    json.verified_identities(agent.identities) do |identity|
      json.type identity.strategy
      json.id identity.identifying_value
      json.attributes do
        json.(identity, *identity.attribute_keys)
      end
    end
  end
end
