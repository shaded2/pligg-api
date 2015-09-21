class ApiKey < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  before_create :generate_access_token, :expire_in_ninety_days

  validates :user_id, presence: true
  validates_uniqueness_of :user_id, message: "only one ApiKey per user"

private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def expire_in_ninety_days
    self.expires_at = Time.now.utc + (60 * 60 * 24 * 90)
  end
end