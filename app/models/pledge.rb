class Pledge < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :dollar_amount, presence: true
  validates :user, presence: true
  validate :check_back_project


end
