require "open-uri"

class Growl < ActiveRecord::Base
  attr_accessible :comment, :link, :user, :type
  validates_presence_of :type
  belongs_to :user
  has_one :meta_data, :autosave => true
  has_attached_file :photo,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :styles => {
                                  :medium => "300x300>",
                                  :thumb => "100x100>"
                               }
  scope :by_date, order("created_at DESC")

  def self.paginated_by_type(type, page)
    by_type(type).by_date.page(page)
  end

  def self.by_type(input)
    input ? where(type: input) : where(:type != nil)
  end

  ["title", "thumbnail_url", "description"].each do |method|
    define_method method.to_sym do
      meta_data ? meta_data.send(method.to_sym) : ""
    end
  end

  ["link", "message", "image"].each do |method|
     define_method "#{method}?".to_sym do
        self.type == method.capitalize
    end
  end

end

# == Schema Information
#
# Table name: growls
#
#  id                 :integer         not null, primary key
#  type               :string(255)
#  comment            :text
#  link               :text
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  user_id            :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

