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
             total_count += 1
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

  def pledges_to_rewards(pledge)
    arr_potential_rewards = []
    arr_potential_rewards_amount = []
    reward_index = 0
    if pledge && rewards
      rewards.each do |reward|

        # sorting technique
        if pledge.dollar_amount>= reward.dollar_amount
          arr_potential_rewards << reward
          arr_potential_rewards_amount << reward.dollar_amount
        end
      end

      reward_index = arr_potential_rewards_amount.each_with_index.max[1]
      best_reward = arr_potential_rewards[reward_index]

      # key association
      best_reward.update(:pledge_id => pledge.id)
      return best_reward
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
