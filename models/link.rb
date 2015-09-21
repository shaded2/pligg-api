class Link < ActiveRecord::Base
  self.table_name = "pligg_links"
  self.primary_key = "link_id"

  validates_uniqueness_of :link_url
  validates :link_url, format: { with: URI.regexp }
  validates_presence_of :link_status, :link_url, :link_title, :link_summary, :link_tags

  before_create :copy_duplicate_required_fields

  private

  def current_time_from_proper_timezone
    self.class.default_timezone = :local
    super
  end

  #override create and update timestamp methods
  def timestamp_attributes_for_create
    super << :link_date
  end

  def timestamp_attributes_for_update
    super << :link_modified
  end

  #account for duplicate required fields
  def copy_duplicate_required_fields
    self.link_randkey = Random.new.rand(1000000...100000000)
    self.link_field1 = "api"
    self.link_title_url = self.link_url_title = self.link_title
    self.link_content = self.link_summary
    self.link_published_date = Time.new('1999') unless self.link_published_date.present?
  end
end