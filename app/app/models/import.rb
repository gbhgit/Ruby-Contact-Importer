class Import < ApplicationRecord
    belongs_to :user
    attr_accessor :header

    has_one_attached :file
    validate :check_file_presence

    def check_file_presence
        errors.add(:file, "no file added") unless file.attached?
    end
end
