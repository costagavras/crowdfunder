require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_email_must_be_unique
    user = User.create(email: "bettymaker@gmail.com", password: "12345678", password_confirmation: "12345678")
    user2 = User.new(email: "bettymaker@gmail.com", password: "00000000", password_confirmation: "00000000")
    refute user2.valid?
  end

  def test_user_must_include_password_confirmation_on_create
    user = User.new(email: "bettymaker@gmail.com", password: "12345678")
    refute user.valid?
  end

  def test_password_must_match_confirmation
    user = User.new(email: "bettymaker@gmail.com", password: "12345678", password_confirmation: "87654321")
    refute user.valid?
  end

  def test_password_must_be_at_least_8_characters_long
    user = User.new(email: "bettymaker@gmail.com", password: "1234", password_confirmation: "1234")
    refute user.valid?
  end


  def test_user_pledges_sum

    user1 = User.create(id: 1, first_name: "Jack", last_name: "Torrance", email: "bettymaker@gmail.com", password: "12345678", password_confirmation: "12345678" )
    user2 = User.create(id: 2, first_name: "Jack2", last_name: "Torrance2", email: "bettymaker2@gmail.com", password: "12345678", password_confirmation: "12345678" )

    project = Project.create!(id: 1, user: user2, title: "XYZ", description: "Do stuff", goal: rand(100000), start_date: DateTime.now.utc + 5000, end_date: Time.now.utc + rand(50).days)

    pledge1 = Pledge.create(user_id: 1, dollar_amount: 20, project_id: 1)
    pledge2 = Pledge.create(user_id: 1, dollar_amount: 30, project_id: 1)
    pledge3 = Pledge.create(user_id: 1, dollar_amount: -5, project_id: 1)

    actual = user1.sum_pledges
    expected = 50

    assert_equal(expected, actual)

  end

end
