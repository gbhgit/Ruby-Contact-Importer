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

  belongs_to :user
  has_one_attached :file
  attr_accessor :header
  
  validates :status, presence: true,
            inclusion: {
              in: status_options.values,
              message: "%{value} is not a valid status"
            }
  validates_size_of :file, maximum: 5.megabytes,
                    message: "should be less than 5MB"
  validate :file_validation
  has_many :logs

  def update_status!(status)
    self.status = status
    self.save
  end

  def proc
    update_status!("processing")
    hash = read_csv_file
    value = hash[:status]
    update_status!(value)
  end

  def file_validation
    errors.add(:file, 'no file added') unless file.attached?
    
    if file.attached? && !file.content_type.in?("text/csv")
      errors.add(:file, "must be a CSV file.")
    end
  end

  def read_csv_file
    imported_count = 0
    line = 0
    headers_failed = false
    tempfile = file.download
    begin
      CSV.parse(tempfile, headers: true) do |row|
        if line == 0
          unless has_valid_headers?(row.headers)
            set_failed_register("Wrong headers")
            headers_failed = true
            break
          end
        end
        line += 1;
        contact_attributes = get_contact_attributes(row)
        contact = Contact.new(contact_attributes)
        contact.user = user
        if contact.valid?
          if user.contacts.find_by(email: contact.email)
            set_failed_register(
              "Line #{line + 1} \
              - \nRow #{row.to_s} \
              - \nthere is already a contact with that email"
            )
            next
          end
        end
        if contact.save
          imported_count += 1
        else
          if contact.errors[:franchise].length > 0
            contact.franchise = "empty"
            contact.credit_card = "is invalid"
            contact.valid?
          end
          set_failed_register(
            "Line #{line + 1} \
            - \nRow #{row.to_s} \
            -\n #{contact.errors.full_messages.join(', ')}"
          )
        end
      end
    rescue => exception
      puts exception
    end
    if headers_failed || (imported_count == 0 && line != 0)
      return { status: "failed" }
    else
      return { status: "finished" }
    end
  end

  def get_contact_attributes(row)
    contact_attributes = {}
    header.each do |key, value|
      contact_attributes[key.to_sym] = row[value]
    end
    franchise_hash = get_franchise(contact_attributes[:credit_card])
    contact_attributes[:credit_card] = encrypt_cc(
                                        contact_attributes[:credit_card]
                                      )
    contact_attributes.merge(franchise_hash)
  end

  def get_franchise(cc)
    if (cc)
      CreditCardValidations.add_brand(:discover, {length: 16, prefixes: '6011'})
      return { franchise: cc.credit_card_brand_name }
    else
      return { franchise: nil }
    end
  end

  def set_failed_register(error_message)
    register = Log.new(error: error_message, import: self)
    register.save
  end

  def has_valid_headers?(headers)
    header.values.each do |value|
      return false unless headers.include?(value)
    end
    true
  end

  def encrypt_cc(cc)
    if(cc)
      return ('*' * (cc.length - 4) + cc[-4, 4])
    else
      return nil
    end
  end
end
