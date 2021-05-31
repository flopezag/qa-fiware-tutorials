# created by Amani Boughanmi on 20.05.2021

Feature: test tutorial 101.Getting Started

Background: 
    Given I set the tutorial

Scenario: GET version request
	Given I send GET HTTP request
	Then the json response is valid
