class Mark < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :exam_type
end
