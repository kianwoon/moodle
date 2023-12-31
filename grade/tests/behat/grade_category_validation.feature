@core_grades @javascript
Feature: Editing a grade item
  In order to ensure validation is provided to the teacher
  As a teacher
  I need to know why I can not add/edit values on the grade category form

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
      | teacher1 | Teacher | 1 | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | Course 1 | C1 | 0 | 1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And I log in as "admin"
    And I navigate to "Grades > Scales" in site administration
    And I press "Add a new scale"
    And I set the following fields to these values:
      | Name  | ABCDEF      |
      | Scale | F,E,D,C,B,A |
    And I press "Save changes"
    And I press "Add a new scale"
    And I set the following fields to these values:
      | Name  | Letter scale                              |
      | Scale | Disappointing, Good, Very good, Excellent |
    And I press "Save changes"
    And I set the following administration settings values:
      | grade_aggregations_visible | Mean of grades,Weighted mean of grades,Simple weighted mean of grades,Mean of grades (with extra credits),Median of grades,Lowest grade,Highest grade,Mode of grades,Natural |
    And I log out
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I press "Add category"
    And I set the following fields to these values:
      | Category name | Cat 1         |
      | Aggregation   | Highest grade |
    And I click on "Save" "button" in the "New category" "dialogue"
    And I wait until the page is ready
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name      | Item 1 |
      | Grade category | Cat 1  |
    And I click on "Save" "button" in the "New grade item" "dialogue"
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name      | Item 2 |
      | Grade category |  Cat 1 |
    And I click on "Save" "button" in the "New grade item" "dialogue"

  Scenario: Being able to change the grade type, scale and maximum grade for a grade category when there are no overridden grades
    Given I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    Then I should not see "This category has associated grade items which have been overridden. Therefore some grades have already been awarded"
    And I expand all fieldsets
    And I set the field "Grade type" to "Scale"
    And I press "Save changes"
    And I should see "Scale must be selected"
    And I set the field "Scale" to "ABCDEF"
    And I press "Save changes"
    And I should not see "You cannot change the type, as grades already exist for this item"
    And I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    And I should not see "This category has associated grade items which have been overridden. Therefore some grades have already been awarded"
    And I expand all fieldsets
    And I set the field "Scale" to "Letter scale"
    And I press "Save changes"
    And I should not see "You cannot change the scale, as grades already exist for this item"

  Scenario: Attempting to change a category item's grade type when overridden grades already exist
    Given I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "20.00" to the user "Student 1" for the grade item "Cat 1 total"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    And I expand all fieldsets
    Then I should see "This category has associated grade items which have been overridden. Therefore some grades have already been awarded, so the grade type cannot be changed. If you wish to change the maximum grade, you must first choose whether or not to rescale existing grades."
    And "//div[contains(concat(' ', normalize-space(@class), ' '), 'felement') and contains(text(), 'Value')]" "xpath_element" should exist

  Scenario: Attempting to change a category item's scale when overridden grades already exist
    Given I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    And I expand all fieldsets
    And I set the field "Grade type" to "Scale"
    And I set the field "Scale" to "ABCDEF"
    And I press "Save changes"
    And I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "C" to the user "Student 1" for the grade item "Cat 1 total"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    And I expand all fieldsets
    Then I should see "This category has associated grade items which have been overridden. Therefore some grades have already been awarded, so the grade type and scale cannot be changed."
    And "//div[contains(concat(' ', normalize-space(@class), ' '), 'felement') and contains(text(), 'ABCDEF')]" "xpath_element" should exist

  Scenario: Attempting to change a category item's maximum grade when no rescaling option has been chosen
    Given I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "20.00" to the user "Student 1" for the grade item "Cat 1 total"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    And I expand all fieldsets
    Then I should see "This category has associated grade items which have been overridden. Therefore some grades have already been awarded, so the grade type cannot be changed. If you wish to change the maximum grade, you must first choose whether or not to rescale existing grades."
    And I should see "Choose" in the "Rescale overridden grades" "field"
    And the "Maximum grade" "field" should be disabled

  Scenario: Perform changes to a grade category with custom decimal separator
    Given the following "language customisations" exist:
      | component       | stringid | value |
      | core_langconfig | decsep   | #     |
    And I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "20#00" to the user "Student 1" for the grade item "Cat 1 total"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "Cat 1" of type "category" on "setup" page
    And I choose "Edit category" in the open action menu
    And I click on "Show more..." "link" in the ".modal-dialog" "css_element"
    And I expand all fieldsets
    And I set the field "Rescale overridden grades" to "Yes"
    And I set the field "Maximum grade" to "87#50"
    When I press "Save changes"
    And I navigate to "View > Grader report" in the course gradebook
    And I click on user menu "Student 1"
    And I choose "Single view for this user" in the open action menu
    Then I should see "Student 1"
    And the field "Grade for Category total" matches value "17#50"
