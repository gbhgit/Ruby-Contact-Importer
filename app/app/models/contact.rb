class Contact < ApplicationRecord
  belongs_to :user

  NAME_REGEX = /\A[a-zA-Z -]+\z/
  BIRTHDATE_REGEX_TYPE_1 = /\A\d{4}-\d{2}-\d{2}\z/
  BIRTHDATE_REGEX_TYPE_2 = /\A\d{4}\d{2}\d{2}\z/
  PHONE_REGEX_TYPE_1 = /\A\(\+\d{2}\) \d{3} \d{3} \d{2} \d{2}\z/
  PHONE_REGEX_TYPE_2 = /\A\(\+\d{2}\) \d{3}-\d{3}-\d{2}-\d{2}\z/
  VALID_CC_REGEX = /\A[\*]+\d{4}\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, format: { with: NAME_REGEX }, length: { minimum: 3 }
  validates :birthdate, presence: true
  validate :birthdate_validation
  validates :phone, presence: true
  validate :phone_validation
  validates :address, presence: true, length: { minimum: 10 }
  validates :credit_card, presence: true, format: { with: VALID_CC_REGEX },
            length: { minimum: 10, maximum: 19 }
  validates :franchise, presence: true, length: { maximum: 75 }
  
  private

  def phone_validation
    unless (PHONE_REGEX_TYPE_1.match(phone) ||
            PHONE_REGEX_TYPE_2.match(phone))
      errors.add(:phone, "error: Telephone Format")
    end
  end

  def birthdate_validation
    if BIRTHDATE_REGEX_TYPE_1.match(birthdate) ||
       BIRTHDATE_REGEX_TYPE_2.match(birthdate)
      begin
        birthdate.to_date
      rescue => exception
        errors.add(:birthdate, "error: Date Value")
      end
    else
      errors.add(:birthdate, "error: Date Format")
    end
  end
end
