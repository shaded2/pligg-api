class User < ActiveRecord::Base
  has_one :api_key

  self.table_name = "pligg_users"
  self.primary_key = "user_id"

  before_create :set_create_times

  private

  #override create and update timestamp methods
  def timestamp_attributes_for_create
    super << :user_date
  end

  def timestamp_attributes_for_update
    super << :user_modification
  end

  def set_create_times
    self.user_lastlogin = Time.new.utc
    self.last_reset_request = Time.new.utc
  end
end