class Item < ActiveRecord::Base
  belongs_to :user
  has_one :profile, through: :user

  validates :name, presence: true
  validates :intro, presence: true
  validates :buy_from, presence: true
  validates :num, presence: true, numericality: { greater_than: 0 }
  validates_format_of :expire_at, with: /\d{2}\-\d{2}\-\d{2}/
end
