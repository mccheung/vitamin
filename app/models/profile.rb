class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :items, through: :user

  def location
    [self.lng, self.lat]
  end

  validates :nickname, presence: true, uniqueness: true

  after_commit on: [:update] do
    ProfileIndexer.perform_async(:update,  self.id)
  end
end
