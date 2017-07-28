class Student < ApplicationRecord
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :grade_id, presence: true
  
  # Associations
  belongs_to :grade
end
