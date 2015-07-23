json.links do
  json.self request.url
end

json.data(@agents) do |agent|
  json.type agent.type
  json.id agent.id

  json.attributes do
    json.strategy agent.strategy
    json.identifying_value agent.identifying_value
  end

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
