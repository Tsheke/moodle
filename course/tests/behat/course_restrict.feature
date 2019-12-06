@core @core_course
Feature: Edit course settings to set visibility to Restrict
  In order to let the course visible but to restrict access to usres with the capability to view hidden courses
  As a teacher
  I need to edit the course settings

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher | Teacher FN | Teacher LN | teacher1@example.com |
      | student1 | Student1 FN | Student1 LN | student1@example.com |
      | student2 | Student2 FN | Student2 LN | student2@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Test course | C1 | 0 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher | C1 | editingteacher |
      | student1 | C1 | student |
    And I log in as "teacher"
    And I am on "Test course" course homepage with editing mode on
    And I add a "Forum" to section "1" and I fill the form with:
      | Forum name | Test content forum |
      | Description | Test forum description |
      | Availability | Show on course page |

  @javascript
  Scenario: Edit course settings and set visibility to hide
    When I navigate to "Edit settings" in current page administration
    And I set the following fields to these values:
      | Course visibility | Hide |
    And I press "Save and display"
    And I follow "Test course"
    Then I should see "Test course"
    And I should see "C1"
    And I log out
    And I log in as "student1"
    And I am on site homepage
    Then I should not see "Test course"
    And I should not see "This course is currently unavailable to students"
    And I log out
    And I log in as "student2"
    And I am on site homepage
    Then I should not see "Test course"

  Scenario: Edit course settings and set visibility to show
    When I navigate to "Edit settings" in current page administration
    And I set the following fields to these values:
      | Course visibility | Show |
    And I press "Save and display"
    And I follow "Test course"
    Then I should see "Test course"
    And I should see "C1"
    And I log out
    And I log in as "student1"
    And I am on site homepage
    Then I should see "Test course"
    And I click on "Test course" "link"
    Then I should see "Test content forum"
    And I should not see "Enrol"
    And I should not see "This course is currently unavailable to students"
    And I log out
    And I log in as "student2"
    And I am on site homepage
    Then I should see "Test course"
    And I click on "Test course" "link"
    Then I should see "Enrol"
    Then I should not see "Test content forum"
    And I should not see "This course is currently unavailable to students"

  Scenario: Edit course settings and set visibility to restrict
    When I navigate to "Edit settings" in current page administration
    And I set the following fields to these values:
      | Course visibility | Restrict |
    And I press "Save and display"
    And I follow "Test course"
    Then I should see "Test course"
    And I should see "C1"
    And I log out
    And I log in as "student1"
    And I am on site homepage
    Then I should see "Test course"
    And I click on "Test course" "link"
    And I should see "This course is currently unavailable to students"
    And I should not see "Test content forum"
    And I log out
    And I log in as "student2"
    And I am on site homepage
    Then I should see "Test course"
    And I click on "Test course" "link"
    Then I should not see "Enrol"
    And I should not see "Test content forum"
    And I should see "This course is currently unavailable to students"
