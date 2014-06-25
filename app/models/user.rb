class User < ActiveRecord::Base
  validates_presence_of :full_name, :password, :email
  validates_uniqueness_of :email
  has_many :reviews
  has_many :queue_items, -> { order(:position) }

  has_secure_password validations: false

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
end