class Company < ApplicationRecord

  has_rich_text :description
  validate :check_email

  def location
    ZipCodes.identify(self.zip_code)
  end

  def check_email
    return true if self.email.empty?
    self.errors.add(:email, "Invalid Email ID") unless self.email.include? "@getmainstreet.com"
  end

end
