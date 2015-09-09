class Item < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :intro, presence: true
  validates :buy_from, presence: true
  validates :num, presence: true, numericality: { greater_than: 0 }
end
