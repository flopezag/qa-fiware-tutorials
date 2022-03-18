Feature: Test tutorial 604.Linked_Data_Subscriptions_and_Registrations (Orion)
  This is feature file of the FIWARE step by step tutorial for Linked Data Subscriptions and Registrations (Orion)
  url: https://fiware-tutorials.readthedocs.io/en/latest/ld-subscriptions-registrations.html
  git-clone: https://github.com/FIWARE/tutorials.LD-Subscriptions-Registrations.git
  git-directory: /tmp/tutorials.LD-Subscriptions-Registrations
  shell-commands: ./services create; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 604

  Scenario: 01 - Retrieve a known store
