class User < ActiveRecord::Base
  validates_presence_of :full_name, :password, :email
  validates_uniqueness_of :email
  has_many :reviews
  has_many :queue_items

  has_secure_password validations: false
end