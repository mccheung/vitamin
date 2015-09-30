class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :items, through: :user

  def location
    [self.lng, self.lat]
  end

  validates :nickname, presence: true, uniqueness: true

  after_commit on: [:update] do
    if address_changed?
      ProfileIndexer.perform_async(:update,  self.id)
    end
  end

  private

  def address_changed?
    previous_changes.has_key?(:address) && previous_changes[:address].any?
  end
end
