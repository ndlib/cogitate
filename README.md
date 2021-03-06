# Cogitate

[![Build Status](https://travis-ci.org/ndlib/cogitate.png?branch=master)](https://travis-ci.org/ndlib/cogitate)
[![Code Climate](https://codeclimate.com/github/ndlib/cogitate.png)](https://codeclimate.com/github/ndlib/cogitate)
[![Test Coverage](https://codeclimate.com/github/ndlib/cogitate/badges/coverage.svg)](https://codeclimate.com/github/ndlib/cogitate)
[![Dependency Status](https://gemnasium.com/ndlib/cogitate.svg)](https://gemnasium.com/ndlib/cogitate)
[![Documentation Status](http://inch-ci.org/github/ndlib/cogitate.svg?branch=master)](http://inch-ci.org/github/ndlib/cogitate)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Welcome to Cogitate, a federated identity management system for managing:

* User identities through:
  * Group membership
  * Alternate authentication strategies (ORCID, email, etc.)
  * Non-verifiable identities (Preferred Name, Scopus, etc.)
  * Parroted identities (ask for the identity of a Kroger Card number, you'll get back a Kroger card number)
* User authentication through various providers

## Sequence Diagram for Cogitate Integration

Below is a diagram detailed the request cycle for integration with Cogitate.

![Sequence Diagram for Cogitate Integration](artifacts/sequence-diagram-for-cogitate-integration.png)

## Heads Up

Mixed within this repository are two concerns:

* Cogitate Rails application, the core of which is in `app/` though it leverages `lib/` files
* Cogitate client gem, which is contained within `lib/`

For now these are kept together for ease of application development.
The cogitate gem can be published via this repository (see cogitate.gemspec) for additional information.

In keeping these together, it is important to understand that files in `lib/` should not reference files in `app/`.
That is a general best practice, however it is a requirement of the cogitate gem.

## Documentation and Semantic Versioning

A note on documentation and semantic versioning.

### Public API (via Yardoc tags)

A Public API means that we are committing to preserving the method
signature, return value, and existence of the method. If we want to
remove this method, we will need to bump to a major version. We should
also provide a deprecation warning and guidance on what to do.

```ruby
# @api public
def method_signature_and_return_value_must_be_preserved
end
```

### Private API (via Yardoc tags)

A Private API means that we are not making promises to preserve
the method signature, return value, or even existence of the
method.

In other words, beware, this method may not be around for the long-haul.

```ruby
# @api private
def method_signature_and_return_value_may_be_changed
end
```

## Authentication

Authentication through Cogitate is a multi-step affair:

1. Client application requests `/authenticate?after_authentication_callback_url=<after_authentication_callback_url>` from Cogitate
1. Cogitate prompts user to choose authentication mechanism; **At present Cogitate makes the decision and redirects to CAS**
1. Authentication Service (i.e. CAS, OAuth2 Provider, etc.) handles authentication and reports back to Cogitate
1. Cogitate issues a ticket to the requesting Client via the given `:after_authentication_callback_url`
1. The Client application claims the ticket from Cogitate via `/claim?ticket=<ticket>`
1. Cogitate processes the claim and responds with a token
1. The Client application parses the token into an Agent

## API

### GET /authenticate?after_authentication_callback_url=<cgi escaped URL>

```console
GET /authenticate?after_authentication_callback_url=https%3A%2F%2Fdeposit.library.nd.edu%2Fafter_authenticate
```

This resource is responsible for brokering the actual authentication service.
Assuming a valid `after_authentication_callback_url`, it will respond with a 302 response (and redirect) to the CAS authentication service.
If an invalid `after_authentication_callback_url` is provided, a 403 response will be given as a response.

Once you have authenticated via an authentication strategy (i.e. CAS),
Cogitate will redirect to the URL specified in the `GET /auth` request's `after_authentication_callback_url` query parameter.
The payload will be a JSON Web Token.
That token should contain enough information for your application to adjudicate authorization questions.

### GET /claim?ticket=<cgi escaped TICKET>

```console
GET /claim?ticket=123456789
```

This resource is responsible for transforming a ticket into a token.

### GET Agents

#### Request

```console
GET /api/agents/:urlsafe_base64_encoded_identifiers
Accept application/vnd.api+json
```

The `:urlsafe_base64_encoded_identifiers` follow the format:

```ruby
require 'base64'
identifier = ":strategy\t:identifying_value"
urlsafe_base64_encoded_identifiers = Base64.urlsafe_encode64(identifier)
```

* `:strategy` is the identifying type (i.e. Netid, Orcid, Email).
* `:urlsafe_base64_encoded_identifiers` is the value/string for that identying type.

```ruby
require 'base64'
Base64.urlsafe_encode64("netid\thworld")
=> "bmV0aWQJaHdvcmxk"
```

**Note:** Delimit multiple identifiers with a new line (i.e. `\n`).

#### Response

```json
{
  "links": {
    "self": "http://localhost:3000/api/agents/bmV0aWQJaHdvcmxk"
  },
  "data": [{
    "type": "agents",
    "id": "bmV0aWQJaHdvcmxk",
    "links": {
      "self": "http://localhost:3000/api/agents/bmV0aWQJaHdvcmxk"
    },
    "attributes": {
      "strategy": "netid",
      "identifying_value": "hworld",
      "emails": ["hworld@nd.edu"]
    },
    "relationships": {
      "identifiers": [{
        "type": "identifiers",
        "id": "bmV0aWQJaHdvcmxk"
      }],
      "verified_identifiers": [{
        "type": "identifiers",
        "id": "bmV0aWQJaHdvcmxk"
      }]
    },
    "included": [{
      "type": "identifiers",
      "id": "bmV0aWQJaHdvcmxk",
      "attributes": {
        "identifying_value": "hworld",
        "strategy": "netid",
        "first_name": "Hello",
        "last_name": "World",
        "netid": "hworld",
        "full_name": "Hello World",
        "ndguid": "nd.edu.hworld",
        "email": "hworld@nd.edu"
      }
    }]
  }]
}
```

## Roadmap

As we looked to break apart our monolith applications, it became clear that we needed a centralized authentication and identity service.
It was also clear that our institutional service was inadequate due to the nature of scholarly collaboration crossing boundaries of institutions and individuals.

### Phase 1

* Agent Identifiers
  * ~~Verified Netid~~
  * ~~Unverified Netid~~
  * ~~Unverified "Parrot" identity (i.e. ask for any identity and you'll at least get it back)~~
  * ~~Verified group~~
  * ~~Unverified group~~ Skip groups associated with unverified identifiers
* Authentication
  * ~~Campus Authentication Service (CAS)~~
  * ~~Handle a request for Cogitate to broker the authentication~~
  * ~~Passback a ticket to the primary application~~
* Communication Channels
  * ~~Extract email from NetID identifier~~
* Client library
  * ~~Decode the JSON Web Token (JWT) into a "User" object and related information~~
    * ~~Levarage RSA public key for decoding the JWT~~

### Phase 2

* Agent Identifiers
  * Verified OAuth2 account (i.e. Orcid)
  * Unverified OAuth2 account (i.e. Orcid)
  * Verified email address
  * Unverified email address
* Authentication
  * OAuth2 provider
  * One-time URL (for emails)
* Communication Channels
  * For a given Agent what are their communication vectors (i.e. Email, Phone #, Twitter handle)

## Tasks and Automation

* Generating documentation: `$ bundle exec yardoc --plugin contracts`
* Running the test suite: `$ rake`
* Run each test in isolation: `$ bin/rspec_isolated`
