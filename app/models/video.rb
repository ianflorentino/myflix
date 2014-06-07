class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order 'created_at DESC' }
  
  validates_presence_of :title, :description

  def self.search_by_title(str)
    return [] if str.blank?
    where("title LIKE ?", "%#{str}%").order("created_at DESC")
  end
end