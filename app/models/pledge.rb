class Pledge < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :dollar_amount, presence: true
  validates :user, presence: true
  validate :back_own_project
end

def back_own_project
    if self.user == self.project.user
      errors.add(:Owner, 'should not be able to pledge towards own project')
    else

    end

end
