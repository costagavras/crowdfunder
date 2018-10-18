require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def test_valid_project_can_be_created
    owner = new_user
    owner.save
    project = build(:project)
    project.user = owner
    project.save!
    assert project.valid?
    assert project.persisted?
    assert project.user
  end

  def test_project_is_invalid_without_owner
    project = build(:project)
    project.user = nil
    project.save
    assert project.invalid?, 'Project should not save without owner.'
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
    my_project = build(:project, goal: -50000)
    my_project.valid?
    assert_includes(my_project.errors.full_messages, "Goal must be greater than 0.0")
  end

  def test_project_start_date_must_be_in_the_future

    start =   DateTime.now - 5000
    finish =  DateTime.now + 1000

    my_project = build(:project, start_date: start, end_date: finish)

    my_project.valid?

    assert_includes(my_project.errors.full_messages, "Start date must be in the future.")
  end

  def test_project_start_date_must_be_before_end_date

    start =   DateTime.now + 1000
    finish =  DateTime.now + 500

    my_project = build(:project, start_date: start, end_date: finish)

    my_project.valid?

    assert_includes(my_project.errors.full_messages, "End date should be later than start date.")
  end

  def test_project_projects_count

    my_project = []
    user = new_user
    user.save

    10.times do
      my_project << create(:project, user: user)
    end

    actual_value = Project.projects_count
    expected_value = 10
    assert_equal(expected_value, actual_value)
  end


end
