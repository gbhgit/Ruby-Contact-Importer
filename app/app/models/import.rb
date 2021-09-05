# frozen_string_literal: true

class Import < ApplicationRecord
  require 'csv'
  require 'credit_card_validations/string'

  enum status_options: {
    on_hold: "on hold",
    processing: "processing",
    failed: "failed",
    finished: "finished",
  }, _prefix: :status
  
  attr_accessor :header

  belongs_to :user
  has_many :logs
  has_one_attached :file
  validates :status, presence: true,
            inclusion: {
              in: status_options.values,
              message: "%{value} is not a valid status"
            }
  validates_size_of :file, maximum: 3.megabytes,
                    message: "should be less than 3MB"
  validate :file_validation
  
  def franchise(cc)
    if (cc)
      CreditCardValidations.add_brand(:discover, {length: 16, prefixes: '6011'})
      return { franchise: cc.credit_card_brand_name }
    else
      return { franchise: nil }
    end
  end

  def encrypt(cc)
    if(cc)
      return ('*' * (cc.length - 4) + cc[-4, 4])
    else
      return nil
    end
  end

  def get_contact(row)
    attributes = {}
    header.each do |key, value|
      attributes[key.to_sym] = row[value]
    end
    hash = franchise(attributes[:credit_card])
    attributes[:credit_card] = encrypt(
      attributes[:credit_card]
                                      )
                                      attributes.merge(hash)
  end

  def has_valid_headers?(headers)
    header.values.each do |value|
      return false unless headers.include?(value)
    end
    true
  end          

  def file_validation
    errors.add(:file, 'no file added') unless file.attached?
    
    if file.attached? && !file.content_type.in?("text/csv")
      errors.add(:file, "must be a .csv extension.")
    end
  end

  def update_status!(status)
    self.status = status
    self.save
  end

  def save_log(message)
    register = Log.new(error: message, import: self)
    register.save
  end

  def run
    update_status!("processing")
    i = 0
    saved = 0
    temp = file.download
    invalid_header = false
    begin
      CSV.parse(temp, headers: true) do |row|
        if i == 0
          unless has_valid_headers?(row.headers)
            save_log("Wrong headers")
            invalid_header = true
            break
          end
        end
        i += 1;
        contact = Contact.new( get_contact(row) )
        contact.user = user
        if contact.valid?
          if user.contacts.find_by(email: contact.email)
            save_log(
              "Line #{i + 1} \
              - \nRow #{row.to_s} \
              - \ncontact email already exist"
            )
            next
          end
        end
        if contact.save
          saved += 1
        else
          if contact.errors[:franchise].length > 0
            contact.franchise = "empty"
            contact.credit_card = "is invalid"
            contact.valid?
          end
          save_log(
            "Line #{i + 1} \
            - \nRow #{row.to_s} \
            -\n #{contact.errors.full_messages.join(', ')}"
          )
        end
      end
    rescue => exception
      puts exception
    end
    if invalid_header || (saved == 0 && i != 0)
      update_status!("failed")
    else
      update_status!("finished")
    end
  end

end
