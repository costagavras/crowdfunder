require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def test_valid_project_can_be_created
    owner = new_user
    owner.save
    project = new_project
    project.user = owner
    project.save!
    assert project.valid?
    assert project.persisted?
    assert project.user
  end

  def test_project_is_invalid_without_owner
    project = new_project
    project.user = nil
    project.save
    assert project.invalid?, 'Project should not save without owner.'
  end

  def new_project
    Project.new(
      title:       'Cool new boardgame',
      description: 'Trade sheep',
      start_date:  DateTime.now + 1.day,
      end_date:    DateTime.now + 1.month,
      goal:        50000
    )
  end

  def new_user
    User.new(
      first_name:            'Sally',
      last_name:             'Lowenthal',
      email:                 'sally@example.com',
      password:              'passpass',
      password_confirmation: 'passpass'
    )
  end

  def test_project_goal_validiation_must_be_a_positive_number

    start =   DateTime.now + 500
    finish =  DateTime.now + 1000

    my_project = Project.new(title: "My Project",
                             description: "My Description",
                             goal: -5,
                             start_date: start,
                             end_date: finish)

    my_project.valid?

    assert_includes(my_project.errors.full_messages, "Goal must be greater than 0.0")
  end

  def test_project_start_date_must_be_in_the_future

    start =   DateTime.now - 5000
    finish =  DateTime.now + 1000

    my_project = Project.new(title: "My Project",
                             description: "My Description",
                             goal: 1000,
                             start_date: start,
                             end_date: finish)

    my_project.valid?

    assert_includes(my_project.errors.full_messages, "Start date must be in the future.")
  end

  def test_project_start_date_must_be_in_the_future

    start =   DateTime.now + 1000
    finish =  DateTime.now + 500

    my_project = Project.new(title: "My Project",
                             description: "My Description",
                             goal: 1000,
                             start_date: start,
                             end_date: finish)

    my_project.valid?

    assert_includes(my_project.errors.full_messages, "End date should be later than start date.")
  end

  def test_project_projects_count

    my_project = []

    10.times do
      my_project << Project.create(title: "My Project",
                                   description: "My Description",
                                   goal: 1000, start_date:"2018-10-18 18:51:32",
                                   end_date: "2018-10-24 18:51:32",
                                   user_id: 2)
    end
    actual_value = Project.projects_count
    expected_value = 10

    assert_equal(expected_value, actual_value)
  end




end
