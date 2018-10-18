class User < ActiveRecord::Base

  has_secure_password
  has_many :pledges
  has_many :my_pledged_projects, through: :pledges, source: :project
  has_many :projects
  has_many :comments


  validates :password, length: { minimum: 8 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :email, uniqueness: true

  def sum_pledges
    if self.pledges
      @pledges = self.pledges
    end
    pledge_total = 0
      @pledges.each do |pledge|
        if pledge.dollar_amount >= 0
          pledge_total += pledge.dollar_amount
        end
      end
      return pledge_total
    end

end
