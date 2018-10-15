class Project < ActiveRecord::Base
  has_many :rewards
  has_many :pledges
  has_many :users, through: :pledges # backers
  belongs_to :user # project owner

  validates :title, :description, :goal, :start_date, :end_date, presence: true
  validates :goal, numericality: {greater_than: 0.0}
  validate :has_owner

end

private

  def has_owner
      if self.user_id

      else
        errors.add(:Project, 'should not save without owner.')
      end
  end
