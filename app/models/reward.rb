class Reward < ActiveRecord::Base
  belongs_to :project
  validates :dollar_amount, presence: true
  validates :dollar_amount, numericality: {greater_than: 0.0}
  validates :description, presence: true


end
