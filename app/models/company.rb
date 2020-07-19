class Company < ApplicationRecord

  has_rich_text :description
  validate :check_email

  attr_accessor :city, :state
  after_initialize :set_attr

  def set_attr
    if self.zip_code.present?
      location = Rails.cache.fetch(self.zip_code)
      unless location.present?
        location = ZipCodes.identify(self.zip_code)
        Rails.cache.write(self.zip_code, location) if location.present?
      end
      self.city = location.try(:[], :city)
      self.state = location.try(:[], :state_code)
    end
  end

  def check_email
    return true if self.email.empty?
    self.errors.add(:email, "Invalid Email ID") unless self.email.include? "@getmainstreet.com"
  end

end
