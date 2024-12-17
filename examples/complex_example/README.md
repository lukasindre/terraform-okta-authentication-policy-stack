# Complex Example
This complex example shows some more flexibility and options for policy configuration.

A couple of groups and network zones are created for use within the module.

The module itself configures the following resources:
- An Authentication Policy
- An implicit deny policy rule with priority of `98`
- The following rules with priority in which they're listed:
  - A rule to deny traffic from Canada
  - A rule that allows access with these criteria:
    - Traffic from the US
    - User in the managed device group
    - User not in the unmanaged device group
    - User is accessing from a chromeOS, macOS, or Windows device
    - User must authenticate daily
  - A rule that allows access with these criteria
    - Traffic is from the US
    - User is in the unmanaged device group
    - User is not in the managed device group
    - User is accessing from an iOS or Android device
    - User must authenticate at every sign in
    - User must authenticate with phishing resistant credentials