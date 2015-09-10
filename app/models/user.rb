class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def email_required?
    false
  end

  def remember_me
    true
  end

  has_many :items
  has_one :profile

  validates :openid, presence: true, uniqueness: true
  accepts_nested_attributes_for :profile
end
