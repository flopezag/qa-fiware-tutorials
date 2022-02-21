Feature: Test tutorial 406.Administrating_XACML_Rules
  This is feature file of the FIWARE step by step tutorial for Administrating XACML rules
  url: https://fiware-tutorials.readthedocs.io/en/latest/administrating-xacml.html
  git-clone: https://github.com/FIWARE/tutorials.Administrating-XACML.git
  git-directory: /tmp/tutorials.Administrating-XACML
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 406

  Scenario: 01 - Creating a new domain

  Scenario: 02 - Request a decision from AuthZForce

  Scenario: 03 - Creating an initial policy set

  Scenario: 04 - Activating the initial policy set

  Scenario: 05 - Request to access to loading in the white zone

  Scenario: 06 - Request to access to loading in the red zone

  Scenario: 07 - Updating a policy set

  Scenario: 08 - Activating an updated policy set

  Scenario: 09 - Request to access to loading in the white zone again

  Scenario: 10 - Request to access to loading in the red zone again

  Scenario: 11 - Create a token with password

  Scenario: 12 - Read a Verb-resource permission

  Scenario: 13 - Read a XACML rule permission

  Scenario: 14 - Deny access to a resource

  Scenario: 15 - Update an XACML permission

  Scenario: 16 - Passing the updated policy set to AuthZForce

  Scenario: 17 - Recreating the policy set

  Scenario: 18 - Permit access to a resource