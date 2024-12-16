# Basic Example
This is a basic example of this module.

We create a network zone and a group to use in the module.

The module itself creates the following:
- An authentication Policy
- An implicit deny policy rule at priority 98
- An access allow policy for the following criteria
  - Traffic originating from the United States via Network Zone
  - User authentication a part of `Example Group One`
  - User is using an iOS device of any state (does not have to be managed, registered, etc.)