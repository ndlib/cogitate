# Cogitate Data Modeling

We do not want to maintain duplicate entries for a NetID backed user.
However, we do need to maintain entries for a NetID backed user's alternate identifiers (i.e. ORCID).
Notre Dame has a GUID for each NetID. This GUID is a suitable proxy for the user's durable identifier.
If the GUID is no longer valid, one of the other durable identifiers could be used.

## Scenarios

Considerations and thoughts
> In the case of Scenario 1, what should we be doing?

> Do we disassociate an invalid NetID from its verified identifiers?
> Do we continue to acknowledge the relationship?
> Is there a policy that should be applicable on the Cogitate side for adjudicating association or disassociation?
> Given the nature of these permissions I believe the best default is to say that if the NetID is no longer valid, our default answer is that there are no

```gherkin
Scenario: 1
Given a deactivated NetID identifier
And the deactivated NetID is in "good standing"
When a request is issued for the given identity's identifiers
Then the response should include unverified associated
Then the response should NOT include unverified associated identities
And the response should include the given identity
```

```gherkin
Scenario: 1a
Given a deactivated NetID identifier
And the deactivated NetID is NOT in "good standing"
When a request is issued for the given identity's identifiers
Then the response should NOT include unverified associated
Then the response should NOT include unverified associated identities
And the response should include the given identity
```

```gherkin
Scenario: 2
Given an unverified identity
When a request is issued for the given identity's identifiers
Then the response should NOT include unverified associated identities
And the response should NOT include verified associated identities
And the response should include the given identity
```

```gherkin
Scenario: 3
Given a verified identity
When a request is issued for the given identity's identifiers
Then the response should NOT include unverified associated identities
And the response should include verified associated identities
And the response should include the given identity
```
