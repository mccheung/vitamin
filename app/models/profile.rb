class Profile < ActiveRecord::Base
  belongs_to :user
  validates :nickname, presence: true, uniqueness: true
end
