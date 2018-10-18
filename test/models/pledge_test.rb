require_relative '../test_helper'

class PledgeTest < ActiveSupport::TestCase

  def test_a_pledge_can_be_created
    pledge = Pledge.create(
      dollar_amount: 99.00,
      project: new_project,
      user: new_user
    )
    pledge.save
    assert pledge.valid?
    assert pledge.persisted?
  end

  def test_owner_cannot_back_own_project
    owner = new_user
    owner.save
    project = new_project
    project.user = owner
    project.save
    pledge = Pledge.new(dollar_amount: 3.00, project: project)
    pledge.user = owner
    pledge.save
    assert pledge.invalid?, 'Owner should not be able to pledge towards own project'
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

  def new_user
    User.new(
      first_name:            'Sally',
      last_name:             'Lowenthal',
      email:                 'sally@example.com',
      password:              'passpass',
      password_confirmation: 'passpass'
    )
  end

  def test_dollar_ammount_must_exist

    start =   DateTime.now + 500
    finish =  DateTime.now + 1000

    pledge = Pledge.new(
      project: new_project,
      user: new_user
    )

    pledge.valid?
    assert_includes(pledge.errors.full_messages, "Dollar amount can't be blank" )
  end

  def test_pledge_count_total
    my_user = []
      my_user1 = User.create(email: "bettymaker@gmail.com", password: "12345678", password_confirmation: "12345678")
      my_user2 = User.create(email: "kekeke@gmail.com", password: "12345678", password_confirmation: "12345678")
      my_project = Project.create(title: "My Project",
                                     description: "My Description",
                                     goal: 1000, start_date:"2018-10-18 18:51:32",
                                     end_date: "2018-10-24 18:51:32",
                                     user: my_user1)
    my_pledge = []

    # 10.times do
    #   # my_pledge << Pledge.create(dollar_amount: 2, project_id: 1, user_id: 5)
    # end
    10.times do
      my_pledge = Pledge.create(dollar_amount: 2, user_id: my_user2.id, project_id: my_project.id)
    end

    expected_value = 20
    actual_value = Project.pledge_count

    assert_equal(expected_value, actual_value)
  end


end
