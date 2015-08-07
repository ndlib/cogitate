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

## API

### GET /auth?after_authentication_callback_url=<cgi escaped URL>

```console
GET /auth?after_authentication_callback_url=https%3A%2F%2Fdeposit.library.nd.edu%2Fafter_authenticate
```

This resource is responsible for brokering the actual authentication service.
Assuming a valid `after_authentication_callback_url`, it will respond with a 302 response (and redirect) to the CAS authentication service.
If an invalid `after_authentication_callback_url` is provided, a 403 response will be given as a response.

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
Base64.urlsafe_encode64("orcid\t0000-0002-1191-0873")
=> "b3JjaWQJMDAwMC0wMDAyLTExOTEtMDg3Mw=="
```

**Note:** Delimit multiple identifiers with a new line (i.e. `\n`).

#### Response

```json
{
  "links": {
    "self": "http://localhost:3000/api/agents/b3JjaWQJMDAwMC0wMDAyLTExOTEtMDg3Mw=="
  },
  "data": [{
    "type": "agents",
    "id": "b3JjaWQJMDAwMC0wMDAyLTExOTEtMDg3Mw==",
    "attributes": {
      "strategy": "orcid",
      "identifying_value": "0000-0002-1191-0873"
    },
    "relationships": {
      "identities": [{
        "type": "unverified/orcid",
        "id": "0000-0002-1191-0873"
      }],
      "verified_identities": []
    }
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
  * Decode the JSON Web Token (JWT) into a "User" object and related information
    * Levarage RSA public key for decoding the JWT

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
