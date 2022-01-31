Feature: Test tutorial 404.Securing microservices with a PEP Proxy (Orion)
  This is feature file of the FIWARE step by step tutorial for securing microservices
  with a PEP Proxy (Orion)
  url: https://fiware-tutorials.readthedocs.io/en/latest/pep-proxy.html
  git-clone: https://github.com/FIWARE/tutorials.PEP-Proxy.git
  git-directory: /tmp/tutorials.PEP-Proxy
  shell-commands: ./services create; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 404

  Scenario: 01 - Create token with password

  Scenario: 02 - Get token info

  Scenario: 03 - Create a PEP Proxy

  Scenario: 04 - Read PEP Proxy details

  Scenario: 05 - Reset password of a PEP Proxy

  Scenario: 06 - Delete a PEP Proxy

  Scenario: 07 - Create an IoT Agent

  Scenario: 08 - Read IoT Agent details

  Scenario: 09 - List IoT Agents

  Scenario: 10 - Reset password of an IoT Agent

  Scenario: 11 - Delete and IoT Agent

  Scenario: 12 - PEP Proxy - No access to orion without an access token

  Scenario: 13 - Keyrock - User obtains an access token

  Scenario: 14 - PEP Proxy accessing Orion with an access token

