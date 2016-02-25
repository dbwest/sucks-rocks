Feature: can learn how good is

  Scenario: comp two terms
    When I search for microsoft
    And I search for apple
    Then apple should have a higher score than microsoft