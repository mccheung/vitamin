class AddUniqueIndexNicknameToProfiles < ActiveRecord::Migration
  def change
    add_index :profiles, :nickname, unique: true
  end
end
