class Contact < ApplicationRecord
  belongs_to :user

  VALID_NAME_REGEX = /\A[a-zA-Z -]+\z/
  validates :name, presence: true, format: { with: VALID_NAME_REGEX },
            length: { maximum: 75 }
  VALID_BIRTHDATE1_REGEX = /\A\d{4}-\d{2}-\d{2}\z/
  VALID_BIRTHDATE2_REGEX = /\A\d{4}\d{2}\d{2}\z/
  validates :birthdate, presence: true
  validate :birthdate_validation
  VALID_PHONE1_REGEX = /\A\(\+\d{2}\) \d{3} \d{3} \d{2} \d{2}\z/
  VALID_PHONE2_REGEX = /\A\(\+\d{2}\) \d{3}-\d{3}-\d{2}-\d{2}\z/
  validates :phone, presence: true
  validate :phone_validation
  validates :address, presence: true, length: { minimum: 7, maximum: 75 }
  VALID_CC_REGEX = /\A[\*]+\d{4}\z/
  validates :credit_card, presence: true, format: { with: VALID_CC_REGEX },
            length: { minimum: 10, maximum: 19 }
  validates :franchise, presence: true, length: { maximum: 75 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 105 }
  
  private

  def birthdate_validation
    if VALID_BIRTHDATE1_REGEX.match(birthdate) ||
       VALID_BIRTHDATE2_REGEX.match(birthdate)
      begin
        birthdate.to_date
      rescue => exception
        errors.add(:birthdate, "wrong date value")
      end
    else
      errors.add(:birthdate, "wrong date format")
    end
  end

  def phone_validation
    unless (VALID_PHONE1_REGEX.match(phone) ||
            VALID_PHONE2_REGEX.match(phone))
      errors.add(:phone, "wrong phone format")
    end
  end
end
