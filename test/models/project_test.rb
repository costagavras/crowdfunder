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

  def test_project_has_many_rewards
    reward1 = create(:reward)
    user = new_user
    user.save
    project = create(:project, user: user, rewards: [reward1])

    expected = [reward1]
    actual = project.rewards

    assert_equal(expected, actual)
  end

  def test_project_has_many_pledges

    user_backing = new_user
    user_owning = new_user

    user_backing.save
    user_owning.save

    new_project = build(:project, user: user_owning)

    pledge = Pledge.create(
      dollar_amount: 50.00,
      project: new_project,
      user: user_backing
    )

    new_project.pledges = [pledge]

    expected = [pledge]
    actual = new_project.pledges

    assert_equal(expected, actual)
  end

  def test_project_has_many_users_through_pledges
    project_owner = new_user
    project_owner.save

    project = create(:project, user: project_owner)

    project_backer = new_user
    project_backer.email = "new.agsdfkjhbfe"
    project_backer.save


    pledge = Pledge.create(
      dollar_amount: 50.00,
      project: project,
      user: project_backer
    )

    expected = project_backer
    actual = project.users.first


    assert_equal(expected, actual)

  end

  def test_project_belongs_to_user
    user = new_user
    user.save
    my_project = create(:project, user: user)

    expected = user
    actual = my_project.user

    assert_equal(expected, actual)
  end

  def test_project_has_many_updates
    my_user = create(:user)
    my_project = create(:project, user: my_user)
    update = create(:update, project: my_project)

    expected = update
    actual = my_project.updates

    assert_includes(actual, expected)
  end

  def test_projects_can_return_in_reverse_chronological_order

    my_user = create(:user)
    my_project = create(:project, user: my_user)
    update1 = create(:update, project: my_project)
    update2 = create(:update, project: my_project)

    expected = [update2, update1]
    actual = my_project.display_reversed
    assert_equal(actual, expected)
  end




end
