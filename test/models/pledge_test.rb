require_relative '../test_helper'

class PledgeTest < ActiveSupport::TestCase

  def test_a_pledge_can_be_created
    user = create(:user)
    user_backing = create(:user, email: "random_email@gmail.com")

    new_project = create(:project, user: user)
    pledge = create(:pledge, user: user_backing, project: new_project)

    pledge.save
    assert pledge.valid?
    assert pledge.persisted?
  end

  def test_owner_cannot_back_own_project

    user = create(:user)
    project = create(:project, user: user)
    pledge = build(:pledge, user: user, project: project)

    assert pledge.invalid?, 'Owner should not be able to pledge towards own project'

  end


  def test_dollar_amount_must_exist

    user = create(:user)
    project = create(:project, user: user)

    pledge = build(:pledge, dollar_amount: nil, user: user, project: project)

    pledge.valid?
    assert_includes(pledge.errors.full_messages, "Dollar amount can't be blank" )
  end

  def test_pledge_count_total
    my_user = []

      my_user1 = create(:user)
      my_user2 = create(:user, email: "oooo@gmail.com")

      my_project = create(:project, user: my_user1)


    my_pledge = []

    10.times do
      my_pledge = create(:pledge, project: my_project, user: my_user2, dollar_amount: 2)
    end

    expected_value = 20
    actual_value = Project.total_pledge_value

    assert_equal(expected_value, actual_value)
  end

  def test_pledge_must_have_a_user

    user1 = create(:user)
    user2 = create(:user, first_name: "Jack2", last_name: "Torrance2", email: "bettymaker2@gmail.com")

    project = create(:project, user: user2)
    pledge = build(:pledge, project: project)

    pledge.valid?
    assert_includes(pledge.errors.full_messages, "User can't be blank" )

  end

  def test_pledge_amount_must_be_equal_or_greater_than_zero

    user1 = create(:user)
    user2 = create(:user, first_name: "Jack2", last_name: "Torrance2", email: "bettymaker2@gmail.com")

    project = create(:project, user: user2)
    pledge = build(:pledge, user: user1, dollar_amount: -10, project: project)

    pledge.valid?
    assert_includes(pledge.errors.full_messages, "Dollar amount must be greater than or equal to 0" )

  end


end
