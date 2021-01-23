class Teacher < ApplicationRecord
    before_save { self.email_id = email_id.downcase }
    validates :first_name, presence: true, length: { maximum: 50 }
    validates :last_name, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # validates :email_id, presence: true, length: { maximum: 255 }, 
    #     format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } 
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    
    has_many :grade_subjects
end
