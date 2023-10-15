Feature: Test tutorial 604.Linked_Data_Subscriptions_and_Registrations (Scorpio)
  This is feature file of the FIWARE step by step tutorial for Linked Data Subscriptions and Registrations (Orion)
  url: https://fiware-tutorials.readthedocs.io/en/latest/ld-subscriptions-registrations.html
  git-clone: https://github.com/FIWARE/tutorials.LD-Subscriptions-Registrations.git
  git-directory: /tmp/tutorials.LD-Subscriptions-Registrations
  shell-commands: ./services create; ./services scorpio
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 604

  Scenario: 01 - Create a subscription (Store 1) - Low stock
    When   I set the "Content-Type" header with the value "application/ld+json"
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/subscriptions/"
    And    the body request described in file "request604-01.json"
    And    I send a POST HTTP request to that url
    Then   I receive a HTTP "201" status code response

  Scenario: 02 - Create a subscription (Store 2) - Low stock
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/subscriptions/"
    And    the body request described in file "request604-02.json"
    And    I send a POST HTTP request to that url
    Then   I receive a HTTP "201" status code response

  Scenario: 03 - Read subscription details
    When   I set the url to "http://localhost:9090/ngsi-ld/v1/subscriptions/"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" status code from Broker with the body "response604-03.json" and exclusions "response604-03.excludes"

  Scenario: 04 - Create a registration
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/csourceRegistrations/"
    And    the body request described in file "request604-04.json"
    And    I send a POST HTTP request to that url
    Then   I receive a HTTP "201" status code response

  Scenario: 05 - Read registration details
    When   I set the "Accept" header with the value "application/ld+json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/csourceRegistrations/"
    And    the params equal to "type=Building"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" status code from Broker with the body "response604-05.json" and exclusions "response604-05.excludes"

  Scenario: 06 - Read from Store 1
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Orion-LD with the body equal to "response604-06.json"

  # Something wrong with the execution of the PATCH, json decode error
  Scenario: 07 - Read direct from the Context Broker
    When   I set the "Content-Type" header with the value "application/ld+json"
    And    I set the url to "http://localhost:3000/static/tweets/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001?attrs=tweets"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Orion-LD with the body equal to "response604-07.json"

  Scenario: 08 - Direct update of the Context Provider
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:3000/static/tweets/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001/attrs"
    And    the body request described in file "request604-08.json"
    And    I send a PATCH HTTP request to that url
    Then   I receive a HTTP "204" status code response
    Then   fail: The "value" content of the "tweets" is bad formatted

  Scenario: 09 - Request the registered attribute
    When   I set the url to "http://localhost:9090/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001?attrs=tweets&options=keyValues"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Orion-LD with the body equal to "response604-09.json"

  Scenario: 10 - Forwarded update
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001/attrs/tweets"
    And    the body request described in file "request604-10.json"
    And    I send a PATCH HTTP request to that url
    Then   I receive a HTTP "204" status code response

  Scenario: 11 - Request the previous forwarded update
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001?attrs=tweets&options=keyValues"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Orion-LD with the body equal to "response604-11.json"
