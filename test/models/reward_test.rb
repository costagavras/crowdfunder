require 'test_helper'

class RewardTest < ActiveSupport::TestCase

  def test_a_reward_can_be_created

    project = new_project
    project.save
    reward = create(:reward, project: project)
    assert reward.valid?
    assert reward.persisted?
  end

  def test_a_reward_cannot_be_created_without_a_dollar_amount

    project = new_project
    project.save
    new_reward = build(:reward, project: project, dollar_amount: nil)
    assert new_reward.invalid?, 'Reward should be invalid without dollar amount'
    #assert new_reward.new_record?, 'Reward should not save without dollar amount'
  end

  def test_a_reward_cannot_be_created_without_a_description

    project = new_project
    project.save
    reward = build(:reward, project: project, description: nil)
    assert reward.invalid?, 'Reward should be invalid without a description'
    #assert reward.new_record?, 'Reward should not save without a description'

  end

  def new_project

    Project.new(
      title:       'Cool new boardgame',
      description: 'Trade sheep',
      start_date:  Date.today,
      end_date:    Date.today + 1.month,
      goal:        50000
    )
  end


  def test_dollar_ammount_must_be_positive
    my_reward = build(:reward, dollar_amount: -50)

    my_reward.valid?
    assert_includes(my_reward.errors.full_messages, "Dollar amount must be greater than 0.0" )
  end

  def test_reward_belongs_to_project
    project = new_project
    project.save
    reward = build(:reward, project: project)

    actual = reward.project
    expected = project

    assert_equal(expected, actual)

  end

  def test_update_pledge_id_in_reward

    user1 = create(:user)
    user2 = create(:user, first_name: "Jack2", last_name: "Torrance2", email: "bettymaker2@gmail.com")

    project = create(:project, user: user2)

    pledge = create(:pledge, user: user1, dollar_amount: 30, project: project)


    reward1 = create(:reward, dollar_amount: 20, project: project)
    reward2 = create(:reward, dollar_amount: 25, project: project)
    reward3 = create(:reward, dollar_amount: 35, project: project)

    reward = project.pledges_to_rewards(pledge)
    # puts reward.inspect
    # binding.prys
    # TESTING THAT THE REWARDS HAVE THE SAME ID, i.e. THEY ARE THE SAME REWARD
    actual = reward.id
    expected = reward2.id

    assert_equal(expected, actual)

  end
end
