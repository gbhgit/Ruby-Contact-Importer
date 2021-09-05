# frozen_string_literal: true

class Import < ApplicationRecord
  belongs_to :user
  attr_accessor :header

  has_one_attached :file
  validate :file_validation

  def update_status!(status)
    self.status = status
    self.save
  end

  def proc
    update_status!("processing")
    # hash = read_csv_file
    # value = hash[:status]
    update_status!("finished")
  end

  def file_validation
    errors.add(:file, 'no file added') unless file.attached?
    
    if file.attached? && !file.content_type.in?("text/csv")
      errors.add(:file, "must be a CSV file.")
    end
  end
end
