class Subject < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 20 }
end
