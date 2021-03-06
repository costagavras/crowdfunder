class Pledge < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :rewards

  validates :dollar_amount, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :user, presence: true
  validate :owner_of_project

  def owner_of_project
    if self.project.user == self.user
      errors.add(:notice, "You're the owner of the project!!!)")
    end
  end



end
