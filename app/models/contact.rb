class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :user_id
  belongs_to :user
  validates :email, :name, presence: true
end
