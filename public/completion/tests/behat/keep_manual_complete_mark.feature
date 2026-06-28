@core @core_completion @javascript
Feature: Keep manually set completion after unlocking activity completion settings
  In order to keep manually marked completion states
  As a teacher
  I need to unlock completion settings of an activity with completed states

  Background:
    Given the following "courses" exist:
      | fullname | shortname | category | enablecompletion |
      | Course 1 | C1        | 0        | 1                |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | Professor | teacher1@example.com |
      | student1 | Student1 | Learner1 | student1@example.com |
      | student2 | Student2 | Learner2 | student2@example.com |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
      | student2 | C1 | student |
    And the following "activities" exist:
      | activity   | course    | idnumber | name         | completion |
      | label      | C1        | a1       | First label  | 1          |
      | label      | C1        | a2       | Second label | 1          |
    And the following "question categories" exist:
      | contextlevel | reference | name           |
      | Course       | C1        | Test questions |
    And the following "questions" exist:
      | questioncategory | qtype     | name           | questiontext              |
      | Test questions   | truefalse | First question | Answer the first question |
    And the following "activities" exist:
      | activity | name           | course | idnumber | attempts | gradepass | completion | completionusegrade | completionpassgrade | completionview |
      | quiz     | Test quiz name | C1     | quiz1    | 4        | 5.00      | 2          | 1                  | 1                   | 1              |
    And quiz "Test quiz name" contains the following questions:
      | question       | page |
      | First question | 1    |

    And I am on the "First label" "label activity editing" page logged in as teacher1
    And I click on "Expand all" "link" in the "region-main" "region"
    And I set the field "Students must manually mark the activity as done" to "1"
    And I press "Save and return to course"
    And I log out

    When I am on the "Course 1" course page logged in as student1
    And the manual completion button of "First label" is displayed as "Mark as done"
    And I toggle the manual completion state of "First label"
    And I am on the "Course 1" course page logged in as student1
    Then the manual completion button of "First label" is displayed as "Done"

    When I am on the "Course 1" course page logged in as student1
    And the "Receive a grade" completion condition of "Test quiz name" is displayed as "todo"
    And the "Receive a passing grade" completion condition of "Test quiz name" is displayed as "todo"
    And the "View" completion condition of "Test quiz name" is displayed as "todo"
    And user "student1" has attempted "Test quiz name" with responses:
      | slot | response |
      |   1  | True     |
    And I follow "Test quiz name"
    Then the "Receive a grade" completion condition of "Test quiz name" is displayed as "done"
    And the "Receive a passing grade" completion condition of "Test quiz name" is displayed as "done"
    And the "View" completion condition of "Test quiz name" is displayed as "done"
    And I am on "Course 1" course homepage
    And the "Receive a grade" completion condition of "Test quiz name" is displayed as "done"
    And the "Receive a passing grade" completion condition of "Test quiz name" is displayed as "done"
    And the "View" completion condition of "Test quiz name" is displayed as "done"
    And I log out

    # Teacher overrides some activities completions states to complete.
    When I am on the "Course 1" course page logged in as teacher1
    And I go to the current course activity completion report

    # Check states
    And "Student1 Learner1, First label: Completed" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1, Second label: Not completed" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1, Test quiz name: Completed" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student2 Learner2, First label: Not completed" "icon" should exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2, Second label: Not completed" "icon" should exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2, Test quiz name: Not completed" "icon" should exist in the "Student2 Learner2" "table_row"

    # Override completion states
    And I click on "Second label" "link" in the "Student1 Learner1" "table_row"
    And I click on "Save changes" "button"
    And I click on "First label" "link" in the "Student2 Learner2" "table_row"
    And I click on "Save changes" "button"
    And I click on "Test quiz name" "link" in the "Student2 Learner2" "table_row"
    And I click on "Save changes" "button"

    # Check states after override
    Then "Student1 Learner1" user has completed "First label" activity
    And "Student1 Learner1, Second label: Completed (set by Teacher Professor)" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1" user has completed "Test quiz name" activity
    And "Student2 Learner2, First label: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2" user has not completed "Second label" activity
    And "Student2 Learner2, Test quiz name: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"

  Scenario: Keep manually set states only, not overridden.
    # Teacher unlock completion settings
    When I am on the "First label" "label activity editing" page logged in as teacher1
    And I click on "Completion conditions" "link"
    And I click on "Unlock completion settings" "button"
    And I set the field "Keep manually set completion states" to "1"
    And I set the field "Keep manually overridden completion states" to "0"
    And I click on "Save and return to course" "button"

    # Check that manually set states remain but overridden states was removed for "First label".
    And I go to the current course activity completion report
    Then "Student1 Learner1" user has completed "First label" activity
    And "Student1 Learner1, Second label: Completed (set by Teacher Professor)" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1" user has completed "Test quiz name" activity
    And "Student2 Learner2, First label: Completed (set by Teacher Professor)" "icon" should not exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2" user has not completed "Second label" activity
    And "Student2 Learner2, Test quiz name: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"

  Scenario: Keep overridden states only, not manually set states.
    # Teacher unlock completion settings
    When I am on the "First label" "label activity editing" page logged in as teacher1
    And I click on "Completion conditions" "link"
    And I click on "Unlock completion settings" "button"
    And I set the field "Keep manually set completion states" to "0"
    And I set the field "Keep manually overridden completion states" to "1"
    And I click on "Save and return to course" "button"

    # Check that manually set states are removed but overridden states remain for "First label".
    And I go to the current course activity completion report
    Then "Student1 Learner1" user has not completed "First label" activity
    And "Student1 Learner1, Second label: Completed (set by Teacher Professor)" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1" user has completed "Test quiz name" activity
    And "Student2 Learner2, First label: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2" user has not completed "Second label" activity
    And "Student2 Learner2, Test quiz name: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"

  Scenario: Recalculate and update completions states as usual, manual completion can not be recalculated
    # Teacher unlock completion settings
    When I am on the "First label" "label activity editing" page logged in as teacher1
    And I click on "Completion conditions" "link"
    And I click on "Unlock completion settings" "button"
    And I set the field "Keep manually set completion states" to "0"
    And I set the field "Keep manually overridden completion states" to "0"
    And I click on "Save and return to course" "button"

    # Check that manually and overridden set states are removed as usual for "First label".
    And I go to the current course activity completion report
    Then "Student1 Learner1" user has not completed "First label" activity
    And "Student1 Learner1, Second label: Completed (set by Teacher Professor)" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1" user has completed "Test quiz name" activity
    And "Student2 Learner2" user has not completed "First label" activity
    And "Student2 Learner2" user has not completed "Second label" activity
    And "Student2 Learner2, Test quiz name: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"

  Scenario: Keep overridden and manually set states.
    # Teacher unlock completion settings
    When I am on the "First label" "label activity editing" page logged in as teacher1
    And I click on "Completion conditions" "link"
    And I click on "Unlock completion settings" "button"
    And I set the field "Keep manually set completion states" to "1"
    And I set the field "Keep manually overridden completion states" to "1"
    And I click on "Save and return to course" "button"

    # Check that manually set and overridden states remain for "First label".
    And I go to the current course activity completion report
    Then "Student1 Learner1" user has completed "First label" activity
    And "Student1 Learner1, Second label: Completed (set by Teacher Professor)" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1" user has completed "Test quiz name" activity
    And "Student2 Learner2, First label: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2" user has not completed "Second label" activity
    And "Student2 Learner2, Test quiz name: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"

  # Scenarii with automatic completion tracking

  Scenario Outline: With automatic completion tracking, only keepin overridden states has effect.
    # Teacher unlock completion settings
    When I am on the "Test quiz name" "quiz activity editing" page logged in as teacher1
    And I click on "Completion conditions" "link"
    And I click on "Unlock completion settings" "button"
    And I set the field "Keep manually set completion states" to "<keepmanual>"
    And I set the field "Keep manually overridden completion states" to "<keepoverridden>"
    And I click on "Save and return to course" "button"

    # Check that keeping manually set states has no effet with automatic completion tracking.
    # Overriden states remain with automatic completion tracking if kept.
    And I go to the current course activity completion report
    Then "Student1 Learner1" user has completed "First label" activity
    And "Student1 Learner1, Second label: Completed (set by Teacher Professor)" "icon" should exist in the "Student1 Learner1" "table_row"
    And "Student1 Learner1" user has completed "Test quiz name" activity
    And "Student2 Learner2, First label: Completed (set by Teacher Professor)" "icon" should exist in the "Student2 Learner2" "table_row"
    And "Student2 Learner2" user has not completed "Second label" activity
    And "Student2 Learner2, Test quiz name: Completed (set by Teacher Professor)" "icon" <should> exist in the "Student2 Learner2" "table_row"

    Examples:
      | keepmanual | keepoverridden | should      |
      | 0          |  0             | should not  |
      | 1          |  0             | should not  |
      | 0          |  1             | should      |
      | 1          |  1             | should      |
