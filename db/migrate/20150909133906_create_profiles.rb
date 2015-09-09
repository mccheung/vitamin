class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :nickname
      t.string :address
      t.float :lng
      t.float :lat
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    User.find_each do |user|
      profile = Profile.new
      profile.user = user
      profile.nickname = user.nickname
      profile.save
    end
  end
end
