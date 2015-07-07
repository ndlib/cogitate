# User Identity Requirements

Goal: To provide a common authentication and identity service for various Curate applications.
By providing this common service, each Curate application need not know about users,
but can instead refer to token based information.

The common authentication service acknowledges that not everyone participating in the Curate ecosystem has a NetID.
As such, we need something to broker the various authentication strategies, with an aim for not requiring duplicate authentication implementations in each application.

The identity service is to help us handle a superset of people than the traditional NetID system.
In the case of ETDs, we have advisor groups in which some people have NetIDs and some do not.
This is even more prevelant in VecNet, and other collaborations.

What follows are a list of feature requirements and out of scope (though nice to have) features.

## Lexicon

* User Credential: a NetID, an ORCID, a Facebook profile, etc.
* Group: a representation of a collection of Users
* Group Membership: the join between a User and a Group
* Group Owner: A User that has a Group Membership with a Group and can modify the Group Membership entries for the given Group.
* Group Member: A User that has a Group Membership with a Group and **cannot** modify the Group Membership entries for the given Group.
* Identifier: a unique durable key that can be leveraged by related applications
* User: a representation of someone or something that can take actions on the system

## Features

### Ability to authenticate for a given user's credentials

* Requirement: A user must be able to authenticate against CAS
* Requirement: A user has an immutable identifier
* Requirement: A session is established that can be leveraged by multiple applications
* Phase 2 Requirement: A user may authenticate via an OAuth2 provider
* Phase 2 Requirement: A user may sponsor another user

### Ability to create arbitrary groups

* Requirement: A user can be a member in more than one group
* Requirement: A group can have one or more members
* Requirement: A group has an immutable identifier
* Requirement: The ability to manage the group membership can be assigned to one or more members of the group
* Requirement: A "super user" can assign membership to a group without being a member of that group
* Out of Scope: Groups have hierarchy; A group can be a member of another group

### Magic Groups

* Requirement: Every user will report as being part of the "All Authenticated Users Group"
* Requirement: Every authenticated user will report as being part of the "Authenticated via <Auth Strategy>"
* Requirement: Every user with a valid NetID will report as being part of the "Notre Dame" group

### Identifiers

* A user's identifier will be unique across group and user identifiers
* A group's identifier will be unique across group and user identifiers
* All external identifiers (i.e. ORCID, Email, OAuth2) must be validated via a custom validation service (OAuth2 authentication, one-time tokens, etc.)

### For a given user, get all associated identifiers

An ability to query all of the associated identifiers for a given user

* Requirement: The query will return the user's personal identifier
* Requirement: The query will return the identifiers of all groups in which the user is a member.
* Nice to Have: As part of the authentication, return a list of identifiers that the user has.

### For a given set of users, get all associated identifiers for each user

This leverages the above feature “For a given user, get all associated identifiers”

### For a given identifier, get all associated users

An ability to query an identifier, and determine all of the users associated with it.

* Requirement: Query one identifier at a time
* Optional: Query multiple identifiers at a time, returning an array

Below is a proposed response document (leveraging JSON-API):

```json
{
  "data": {
    "type": "keys",
    "id": ":key_id",
    "attributes": { "name": "key_name" },
    "relationships": {
      "users": [
        { "type": "users", "id": ":user_id", "attributes": { "name": ":user_name", "email": ":email" } }
      ]
    }
  }
}
```

### For a given set of identifiers, get all associated users for each identifier

An ability to determine who all is associated with each identifier.
The purpose of this feature is to reduce the number of calls to this service.

An example use case is sending emails based as part of a Sipity action.
In Sipity Roles will be associated with identifiers. Different roles receive different emails.
So instead of querying one at a time, I'd like to have that information available in one large call.

This leverages the above feature “For a given identifier, get all associated users”

## Routes:

This is the query end point for information about identifiers.

### GET identifiers

```console
GET /api/v1/identifiers?ids=1,2,3
Accept: application/vnd.api+json
```

The response document. Note this returns heterogenous data (groups and users)

```json
{
  "links": {
    "self":"http://cogitate.library.nd.edu/api/v1/identifiers?ids=1,2"
  },
  "data": [{
    "type": "groups",
    "id": "1",
    "attributes": { "name": "Grad School Reviewers" },
    "relationships": {
      "users": [
        { "type": "users", "id": "42", "attributes": { "name": "Douglas Adams", "email": "solong@allthefish.com" } }
      ]
    }},{
    "type": "users",
    "id": "2",
    "attributes": { "name": "Paul Atreides", "email": "muadib@arrakis.com" },
    "relationships": {
      "groups": [
        { "type": "groups", "id": "42", "attributes": { "name": "Fremen" } }
      ]
    }
  }]
}
```

### GET auto-complete

A means of looking up Groups or Users (or both) to allow for auto completion.
This is a non-paginated return (you can specify the count you want).
The reason for non-paginated results is that we need to generate a union of results:

* Notre Dame's LDAP (for campus entities)
* Non-ND's users that have registered via Orcid, Email, Github, etc.
* A user that has connected their NetID with an Orcid, non-ND email, etc.

The Notre Dame NetIDs are not stored locally, whereas the other identifiers are stored locally.

```console
GET /api/v1/auto-complete?q=:query_string(&type=(groups|users))(&count=20)
Accept: application/vnd.api+json
```

```json
{
  "links": {
    "self": "http://cogitate.library.nd.edu/api/v1/auto-complete?q=:query_string"
  },
  "data": [{
    "type": "groups",
    "id": "1",
    "attributes": { "name": "Grad School Reviewers" },
    "relationships": {
      "users": [
        { "type": "users", "id": "42", "attributes": { "name": "Douglas Adams", "email": "solong@allthefish.com" } }
      ]
    }},{
    "type": "users",
    "id": "2",
    "attributes": { "name": "Paul Atreides", "email": "muadib@arrakis.com" },
    "relationships": {
      "groups": [
        { "type": "groups", "id": "42", "attributes": { "name": "Fremen" } }
      ]
    }
  }]
}
```

### POST authenticate

The following route is used for authentication.
It will broker the authentication experience and once authenticated will redirect to the `on_success` URL.

```console
POST /api/v1/authenticate?on_success=https://curate.nd.edu/
```

This will return a [pubtkt](https://neon1.net/mod_auth_pubtkt/install.html).

```console
uid: Identifier of the user
validuntil: Unix timestamp indicating when signout occurs
tokens: Comma separated identifiers
udata: JSON-API data of User and Authentication attributes
```

Considerations: When returning to the `on_success`, do we care about the method of authentication?

### GET authenticate by token

Expose a means of authentication via a token.

```console
GET /api/v1/authenticate/by_token/:token
```

This returns a pubtkt as per the `POST authenticate` request
