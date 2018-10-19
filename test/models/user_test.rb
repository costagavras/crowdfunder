require 'test_helper'

class UserTest < ActiveSupport::TestCase

# validation tests-------------------------------------------------------------------------------------

  def test_email_must_be_unique
    # user = User.create(email: "bettymaker@gmail.com", password: "12345678", password_confirmation: "12345678")
    # user2 = User.new(email: "bettymaker@gmail.com", password: "00000000", password_confirmation: "00000000")
    # refute user2.valid?
    user = create(:user, password: "12345678", password_confirmation: "12345678" )
    user2 = build(:user,password: "00000000", password_confirmation: "00000000")
    refute user2.valid?

  end

  def test_user_must_include_password_confirmation_on_create
    # user = User.new(email: "bettymaker@gmail.com", password: "12345678")
    user = build(:user, password_confirmation: "")
    refute user.valid?
  end

  def test_password_must_match_confirmation
    # user = User.new(email: "bettymaker@gmail.com", password: "12345678", password_confirmation: "87654321")
    user = build(:user, password_confirmation: "87654321")
    refute user.valid?
  end

  def test_password_must_be_at_least_8_characters_long
    # user = User.new(email: "bettymaker@gmail.com", password: "1234", password_confirmation: "1234")
    user = build(:user, password: "1234", password_confirmation: "1234")
    refute user.valid?
  end

#unit tests-------------------------------------------------------------------------------------

  def test_user_pledges_sum
    # user1 = User.create(id: 1, first_name: "Johnnie", last_name: "Torrance", email: "bettymaker@gmail.com",
    #   password: "12345678", password_confirmation: "12345678" )
    # user2 = User.create(id: 2, first_name: "Johnnie2", last_name: "Torrance2", email: "bettymaker2@gmail.com",
    #   password: "12345678", password_confirmation: "12345678" )
    user1 = create(:user)
    user2 = create(:user, first_name: "Jack2", last_name: "Torrance2", email: "bettymaker2@gmail.com")

    # project = Project.create!(user: user2, title: "XYZ", description: "Do stuff", goal: rand(100000),
    # start_date: DateTime.now.utc + 5000, end_date: Time.now.utc + rand(50).days)
    project = create(:project, user: user2)

    # pledge1 = Pledge.create(user: user1, dollar_amount: 20, project: project)
    # pledge2 = Pledge.create(user: user1, dollar_amount: 30, project: project)
    # pledge3 = Pledge.create(user: user1, dollar_amount: -5, project: project)
    pledge1 = create(:pledge, user: user1, dollar_amount: 20, project: project)
    pledge2 = create(:pledge, user: user1, dollar_amount: 30, project: project)

    actual = user1.sum_pledges
    expected = 50

    assert_equal(expected, actual)

  end

#association tests-------------------------------------------------------------------------------------
  def test_project_belongs_to_user
    user = create(:user)
    # project = Project.create(user: user, title: "XYZ", description: "Do stuff", goal: rand(100000),
    # start_date: DateTime.now.utc + 5000, end_date: Time.now.utc + rand(50).days)
    project = create(:project, user: user)

    actual = user.projects.first
    expected = project

    assert_equal(expected, actual)
  end

  def test_pledge_belongs_to_user
    user1 = create(:user)
    user2 = create(:user, first_name: "Jack2", last_name: "Torrance2", email: "bettymaker2@gmail.com")

    # project = Project.create(user: user2, title: "XYZ", description: "Do stuff", goal: rand(100000),
    # start_date: DateTime.now.utc + 5000, end_date: Time.now.utc + rand(50).days)
    project = create(:project, user: user2)

    # pledge = Pledge.create(user: user1, dollar_amount: 20, project: project)
    pledge = create(:pledge, user: user1, project: project)

    actual = user1.pledges.first
    expected = pledge

    assert_equal(expected, actual)

  end

end
