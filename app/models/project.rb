class Project < ActiveRecord::Base
  has_many :rewards
  has_many :pledges
  has_many :users, through: :pledges # backers
  belongs_to :user # project owner
  has_many :comments
  has_many :updates

  validates :title, :description, :goal, :start_date, :end_date, presence: true
  validates :goal, numericality: {greater_than: 0.0}

  validate :check_date
  validate :has_owner

  def display_reversed
    return self.updates.order('created_at DESC')
  end

  def self.projects_count
      Project.all.count
  end

  def self.fund_count
      total_count = 0

       Project.all.each do |project|
          if project.pledges
            pledge_count = 0
            project.pledges.each do |pledge|
              pledge_count += pledge.dollar_amount
            end
            if pledge_count >= project.goal
              total_count += 1
            end
          end
      end
      total_count
  end

  def self.total_pledge_value
     pledge_count = 0
      Project.all.each do |project|
        if project.pledges
         project.pledges.each do |pledge|
           pledge_count += pledge.dollar_amount
         end
        end
      end
     pledge_count
  end

  def self.pledges_to_rewards
      if self.user == current_user && self.pledges && self.rewards
        self.pledges each do |pledge|
          self.rewards each do |reward|
            Rewards.where(pledge.dollar_amount>= reward.dollar_amount)

          end
        end
      end


  end


  private

  def has_owner
    if self.user_id

    else
      errors.add(:Project, 'should not save without owner.')
    end
  end

  def check_date

    if !self.start_date
      errors.add(:start_date, 'must not be blank.')
    elsif !self.end_date
      errors.add(:end_date, 'must not be blank.')
    else
      if self.start_date < Time.now
        errors.add(:start_date, 'must be in the future.')
      elsif self.start_date > self.end_date
        errors.add(:end_date, 'should be later than start date.')
      end
    end

  end

  end
