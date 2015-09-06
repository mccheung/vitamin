class Item < ActiveRecord::Base
  after_initialize :set_default_values
  
  belongs_to :user

  validates :name, presence: true
  validates :num, presence: true

  def set_default_values
    self.num ||= 0
  end
end
