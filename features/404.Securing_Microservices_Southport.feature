Feature: Test tutorial 404.Securing microservices with a pep proxy PEP Proxy (IoT Agent - Southport)
  This is feature file of the FIWARE step by step tutorial for securing microservices
  with a PEP Proxy (IoT Agent - Southport)
  url: https://fiware-tutorials.readthedocs.io/en/latest/pep-proxy.html
  git-clone: https://github.com/FIWARE/tutorials.PEP-Proxy.git
  git-directory: /tmp/tutorials.PEP-Proxy
  shell-commands: ./services create; ./services southport
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 404

  Scenario: 15 - Keyrock - IoT Sensor obtains an access token

  Scenario: 16 - PEP Proxy - Accessing IoT Agent with an access token

