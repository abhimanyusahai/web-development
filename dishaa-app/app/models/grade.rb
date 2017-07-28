class Grade < ApplicationRecord
  validates :grade, presence: true
  # Associations
  has_many :students
end
