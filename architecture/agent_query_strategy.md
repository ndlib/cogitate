# Agent Query Strategies

An Agent represents someone/something that can have:

* Authentication vectors.
* Communication vectors
* Identities
* Group memberships

Authentication vectors may be verified or unverified (i.e. the Agent has not verified that they can authenticate with this vector). Examples include: ORCID, ND NetID, Twitter, Facebook, Email address

Communication vectors are means used to communicate with the agent; If we need to broadcast something then we would use the communication vector. Examples include: Preferred Name, Preferred Email Address

Identities are a super set of authentication vectors. Examples of Identities include: ORCID, Scopus, Research ID. An identity cannot be used as for a permission-based access.

Group memberships are analogue to identities, except they are administered by a trusted administrator, and as such can be used for a permission-based access.

Adding a complication is that I do not want to persist NetIDs unless they are used to associate with other identities, authentication vectors, etc.

## Scenarios to Consider

* Query for
  * A NetID authentication vector
    * when the NetID is valid
      * and there is a mix of verified and unverified associated authentication vectors
      * and there are NOT verified associated authentication vectors
    * when the NetID is invalid
      * and there is a mix of verified and unverified associated authentication vectors
      * and there are NOT verified associated authentication vectors
  * An ORCID (or other non NetID) authentication vector
    * when the ORCID has been verified
      * and there is a mix of verified and unverified associated authentication vectors
      * and there are NOT verified associated authentication vectors
    * when the ORCID has not been verified
      * and there is a mix of verified and unverified associated authentication vectors
      * and there are NOT verified associated authentication vectors
  * An identity that is not an authentication vector
    * and there is a mix of verified and unverified associated authentication vectors

## API Response Document

Below is a proposed JSON-API formatted response document for a query.
The response document assumes `:urlsafe_base64_encoded_identifiers` is for a single agent's identity.

```json
{
  "links": {
    "self": "http://cogitate.library.nd.edu/identifiers/:urlsafe_base64_encoded_identifiers"
  },
  "data": [{
    "type": "agents",
    "id": "1",
    "attributes": { "preferred_name": "Jeremy Friesen", "preferred_email": "jeremy@friesen.com" },
    "relationships": {
      "identifiers": [
        { "type": "verified_authentication_vectors", "id": "1234", "attributes": { "type": "netid" } },
        { "type": "identifiers", "id": "abc", "attributes": { "type": "scopus" } },
        { "type": "groups", "id": "abc", "attributes": { "name": "Cogitate Developer" } },
      ],
      "communication_vectors": [
        { "type": "communication_vectors", "id": "jeremy@friesen.com", "attributes": { "type": "preferred_email" } },
      ]
    }
  }]
}
```
