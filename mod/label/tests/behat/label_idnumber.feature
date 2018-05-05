@mod @mod_label

Feature: set label idnumber
  In order to set label idnumber
  As a teacher
  I should create label activity and set an ID Number

  @javascript
  Scenario: label ID number input box should be shown.
    Given the following "courses" exist:
      | fullname | shortname | category |
      | Test | C1 | 0 |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher | Teacher | Frist | teacher1@example.com |
      | student | Student | First | student1@example.com |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher | C1 | editingteacher |
      | student | C1 | student |
    Given I log in as "teacher"
    And I am on "Test" course homepage with editing mode on
    When I add a "label" to section "1" and I fill the form with:
      | Label text | Label with ID number set |
      | Availability | Show on course page |
      | ID number | C1LABEL1 |
    Then "Label with ID number set" activity should be visible
    And I turn editing mode off
    And "Label with ID number set" activity should be visible
    And I log out
    And I log in as "student"
    And I am on "Test" course homepage
    And I should see "Label with idnumber set"
    And I log out
    And I log in as "teacher"
    And I am on "Test" course homepage
    And I turn editing mode on
    And I open "Label with idnumber set" actions menu
    And I click on "Edit settings" "link" in the "Label with idnumber set" activity
    And I expand all fieldsets
    And the "ID number" input box should contain "C1LABEL1"
    And I log out
