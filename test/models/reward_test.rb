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
    reward = Reward.create(
      description: 'A heartfelt thanks!',
      project: project,
    )

    my_association = reward.project
    expected = project

    assert_equal(expected, my_association)

  end






end
