class AddRemarkToItems < ActiveRecord::Migration
  def change
    add_column :items, :remark, :text, after: :expire_at
  end
end
