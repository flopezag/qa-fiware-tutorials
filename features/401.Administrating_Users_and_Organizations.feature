Feature: Test tutorial 401.Administrating Users and Organizations
    This is feature file of the FIWARE step by step tutorial for Administrating Users and Organizations
    url: https://fiware-tutorials.readthedocs.io/en/latest/identity-management.html
    git-clone: https://github.com/FIWARE/tutorials.Identity-Management.git
    git-directory: /tmp/tutorials.Identity-Management
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 401

  Scenario: 00 - Reading directly from the Keyrock MySQL Database
    Given  I connect to the MySQL docker instance with the following data
      | DockerInstance | User | Password | Database | Columns                       | Table |
      | db-mysql       | root | secret   | idm      | id, username, email, password | user  |
    When   I request the information from user table
    Then   I obtain the following data from MySQL
      | id    | username | email          | password |
      | admin | admin    | admin@test.com | ANY      |