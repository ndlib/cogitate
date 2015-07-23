# Cogitate

[![Build Status](https://travis-ci.org/ndlib/cogitate.png?branch=master)](https://travis-ci.org/ndlib/cogitate)
[![Code Climate](https://codeclimate.com/github/ndlib/cogitate.png)](https://codeclimate.com/github/ndlib/cogitate)
[![Test Coverage](https://codeclimate.com/github/ndlib/cogitate/badges/coverage.svg)](https://codeclimate.com/github/ndlib/cogitate)
[![Dependency Status](https://gemnasium.com/ndlib/cogitate.svg)](https://gemnasium.com/ndlib/cogitate)
[![Documentation Status](http://inch-ci.org/github/ndlib/cogitate.svg?branch=master)](http://inch-ci.org/github/ndlib/cogitate)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Welcome to Cogitate, a federated identity management system for managing:

* User authentication through various providers
* User identities through:
  * Group membership
  * Alternate authentication strategies (ORCID, email, etc.)
  * Non-verifiable identities (Preferred Name, Scopus, etc.)

## Roadmap

### Phase 1

* Agent Identifiers
  * ~~Verified Netid~~
  * ~~Unverified Netid~~
  * Verified group
  * Unverified group
* Authentication
  * Campus Authentication Service (CAS)

### Phase 2

* Agent Identifiers
  * Verified OAuth2 account (i.e. Orcid)
  * Unverified OAuth2 account (i.e. Orcid)
  * Verified email address
  * Unverified email address
* Authentication
  * OAuth2 provider
  * One-time URL (for emails)

## Tasks and Automation

* Generating documentation: `$ bundle exec yardoc --plugin contracts`
* Running the test suite: `$ rake`
