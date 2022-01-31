Feature: Test tutorial 404.Securing microservices with a PEP Proxy (IoT Agent - Northport)
  This is feature file of the FIWARE step by step tutorial for securing microservices
  with a PEP Proxy (IoT Agent - Northport)
  url: https://fiware-tutorials.readthedocs.io/en/latest/pep-proxy.html
  git-clone: https://github.com/FIWARE/tutorials.PEP-Proxy.git
  git-directory: /tmp/tutorials.PEP-Proxy
  shell-commands: ./services create; ./services northport
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 404

  Scenario: 17 - Keyrock - Obtaining a permanent token

  Scenario: 18 - IoT Agent - Provisioning a trusted service group

  Scenario: 19 - IoT Agent - Provisioning a sensor

